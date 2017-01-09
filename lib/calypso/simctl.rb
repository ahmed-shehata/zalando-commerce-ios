require 'json'
require 'thor'

require_relative 'consts'
require_relative 'run'
require_relative 'log'

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
    def create(device_name, runtime_name, name = nil)
      create_simulator(device_name, runtime_name, name)
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
      name ||= "Test #{device_name} / #{runtime_name} (#{(rand * 1_000_000).to_i.to_s(16).rjust(10, '0')})"
      dev_id = find_device_type(device_name)
      runtime_id = find_runtime(runtime_name)
      udid = run_simctl('create', "'#{name}'", dev_id, runtime_id).strip
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
      `killall -9 Simulator`
      run_simctl('delete', udid)
      log_debug "Simulator #{udid} deleted"
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

    def find_device_type(name)
      simulators_list['devicetypes'].select do |dev|
        dev['name'] == name
      end.first['identifier']
    end

    def find_runtime(name)
      print "Finding runtime #{name}... "
      runtime = simulators_list['runtimes'].select do |dev|
        dev['name'] == name
      end.first
      log_abort('Not found') if runtime.nil?
      runtime['identifier']
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
