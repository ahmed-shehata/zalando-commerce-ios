require 'json'
require 'thor'
require 'English'

require_relative 'consts'
require_relative 'utils/run'
require_relative 'utils/log'

module Calypso

  class SimCtl < Thor

    KEYBOARD_PREFERENCES = {
      'bool': {
        'KeyboardAllowPaddle': 'NO',
        'KeyboardAssistant': 'NO',
        'KeyboardAutocapitalization': 'NO',
        'KeyboardAutocorrection': 'NO',
        'KeyboardCapsLock': 'NO',
        'KeyboardCheckSpelling': 'NO',
        'KeyboardPeriodShortcut': 'NO',
        'KeyboardPrediction': 'NO',
        'KeyboardShowPredictionBar': 'NO'
      }
    }.freeze

    desc 'disable_keyboard_magic <udid>', 'Turn offs all the automated keyboard behaviours'
    def disable_keyboard_magic(simulator_id)
      KEYBOARD_PREFERENCES.each do |value_type, values|
        next unless value_type == :bool # others not supported, yet
        values.each do |key, val|
          run "defaults write #{preferences_path simulator_id} #{key} -bool #{val}"
        end
      end
    end

    desc 'create <device_type> <runtime_name> [name]', 'Creates simulator'
    def create(device_type, runtime_name, name = nil)
      create_simulator(device_type, runtime_name, name)
    end

    desc 'repopulate', 'Deletes all simulators and creates new ones'
    def repopulate
      repopulate_all_simulators
    end

    desc 'delete <udid>', 'Deletes simulator'
    def delete(udid)
      delete_simulator(udid)
    end

    desc 'list [state]', 'List all simulators'
    def list(state = nil)
      device_types_list.each do |runtime, devices|
        log "** #{runtime} **", color: '1;35'
        devices.each do |dev|
          desc = "#{dev['name'].color('1;34')} (#{dev['udid']}), #{dev['state'].color('1')}"
          next unless state.nil? || /#{state}/i =~ desc
          log " - #{desc}", color: '0'
        end
      end
    end

    no_commands do
      def run_with_simulator(device_name, runtime_name)
        udid = create_simulator(device_name, runtime_name)
        open_simulator udid
        yield udid
        delete_simulator udid
      end
    end

    private

    def create_simulator(device_name, runtime_name, name = nil)
      dev = find_latest_device(device_name)
      dev_name = dev['name']
      dev_id = dev['identifier']

      rt = find_latest_runtime(runtime_name)
      rt_name = rt['name']
      rt_id = rt['identifier']

      name ||= "Test #{dev_name} / #{rt_name} (#{(rand * 1_000_000).to_i.to_s(16).rjust(10, '0')})"

      udid = run_simctl('create', "'#{name}'", dev_id, rt_id).strip
      log_debug "Simulator '#{name}' (#{udid}) created"
      disable_keyboard_magic(udid)
      udid
    end

    def delete_simulators(name)
      find_devices(name).each do |dev|
        delete_simulator dev['udid']
      end
    end

    def delete_simulator(udid)
      dev = find_device(udid)
      shutdown_simulator(udid) unless dev['state'] == 'Shutdown'
      `killall -9 Simulator 2> /dev/null`
      run_simctl('delete', udid)
      log_debug "Simulator #{dev['name']} (#{udid}) deleted"
    end

    def boot_simulator(udid)
      log_debug "Simulator #{udid} booting"
      run_simctl('boot', udid)
    end

    def open_simulator(udid)
      log_debug "Simulator #{udid} starting"
      %(open -a "simulator" --args -CurrentDeviceUDID #{udid})
    end

    def shutdown_simulator(udid)
      log_debug "Simulator #{udid} shutting down"
      run_simctl('shutdown', udid)
    end

    def find_latest_device(name)
      print "Finding device #{name}... "
      selected_devices = simulators_list['devicetypes'].select do |dev|
        dev['name'] =~ /#{name}/i
      end
      device = selected_devices.sort_by do |dev|
        dev['identifier']
      end.last
      log_abort("Device #{name} not found") if device.nil?
      puts device['name']
      device
    end

    def find_latest_runtime(name)
      print "Finding runtime #{name}... "
      selected_runtimes = simulators_list['runtimes'].select do |rt|
        rt['name'] =~ /#{name}/
      end
      runtime = selected_runtimes.sort do |lhs, rhs|
        lhs['version'].to_f <=> rhs['version'].to_f
      end.last

      log_abort("Runtime #{name} not found") if runtime.nil?
      puts runtime['name']
      runtime
    end

    def repopulate_all_simulators
      simulators_list['devices'].each do |_, runtime_devices|
        runtime_devices.each do |device|
          delete_simulator device['udid']
        end
      end

      available_runtimes.each do |runtime|
        log "## Populating #{runtime['name']}"
        simulators_list['devicetypes'].each do |device_type|
          simulator_name = "#{device_type['name']} (#{runtime['name']})"
          args = ["'#{simulator_name}'", device_type['identifier'], runtime['identifier']]
          `xcrun simctl create #{args.join ' '} 2> /dev/null`
          log_debug "Created #{simulator_name}" if $CHILD_STATUS.success?
        end
      end
    end

    def find_devices(name)
      devices_list.select do |dev|
        dev['name'] =~ name
      end
    end

    def find_device(udid)
      devices_list.select do |dev|
        dev['udid'] == udid
      end.first
    end

    def devices_list
      simulators_list['devices'].zip.flatten
    end

    def device_types_list
      simulators_list['devices']
    end

    def available_runtimes
      simulators_list['runtimes'].select do |runtime|
        runtime['availability'] == '(available)'
      end
    end

    def simulators_list
      JSON.parse run_simctl('list', '-j')
    end

    def run_simctl(*args)
      `xcrun simctl #{args.join ' '}`
    end

    def preferences_path(uuid)
      "~/Library/Developer/CoreSimulator/Devices/#{uuid}/data/Library/Preferences/com.apple.Preferences.plist"
    end

    include Log
    include Run

  end

end
