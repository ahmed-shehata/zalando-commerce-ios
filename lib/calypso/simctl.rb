require 'json'
require 'thor'

module Calypso

  class SimCtl

    def run_with_simulator(device_name, runtime_name)
      udid = create_simulator(device_name, runtime_name)
      open_simulator udid
      yield udid
      delete_simulator udid
    end

    private

    def create_simulator(device_name, runtime_name, name = nil)
      name ||= "Test #{device_name} / #{runtime_name} (#{(rand * 1_000_000).to_i.to_s(16).rjust(10, '0')})"
      dev_id = find_device_type(device_name)
      runtime_id = find_runtime(runtime_name)
      udid = run_simctl('create', "'#{name}'", dev_id, runtime_id).strip
      puts "Simulator '#{name}' (#{udid}) created"
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
      puts "Simulator #{udid} deleted"
    end

    def boot_simulator(udid)
      puts "Simulator #{udid} booting"
      run_simctl('boot', udid)
    end

    def open_simulator(udid)
      puts "Simulator #{udid} starting"
      %(open -a "simulator" --args -CurrentDeviceUDID #{udid})
    end

    def shutdown_simulator(udid)
      puts "Simulator #{udid} shutting down"
      run_simctl('shutdown', udid)
    end

    def find_device_type(name)
      list['devicetypes'].select do |dev|
        dev['name'] == name
      end.first['identifier']
    end

    def find_runtime(name)
      list['runtimes'].select do |dev|
        dev['name'] == name
      end.first['identifier']
    end

    def find_devices(name)
      list['devices'].zip.flatten.select do |dev|
        dev['name'] =~ name
      end
    end

    def find_device(udid)
      list['devices'].zip.flatten.select do |dev|
        dev['udid'] == udid
      end.first
    end

    def list
      JSON.parse run_simctl('list', '-j')
    end

    def run_simctl(*args)
      `xcrun simctl #{args.join ' '}`
    end

  end

end
