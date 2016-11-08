require 'thor'
require_relative 'consts'
require_relative 'run'
require_relative 'env'
require_relative 'simctl'

module Calypso

  class Xcode < Thor

    desc 'schemes', 'Shows available schemes'
    def schemes
      run base_build_cmd(WORKSPACE, '-list')
    end

    desc 'test [tries] [scheme]', "Runs tests for given scheme or #{SCHEME_UI_UNIT_TESTS}"
    def test(tries = 1, scheme = SCHEME_UI_UNIT_TESTS)
      exec_tests scheme, tries
    end

    desc 'build [scheme]', 'Builds given scheme'
    def build(scheme = SCHEME_UNIT_TESTS)
      exec_build scheme
    end

    desc 'analyze [scheme]', 'Analyzes given scheme'
    def analyze(scheme = SCHEME_UNIT_TESTS)
      exec_analyze scheme
    end

    desc 'clean [scheme]', 'Cleans given scheme'
    def clean(scheme = SCHEME_UNIT_TESTS)
      exec_clean scheme
    end

    private

    include Run

    def exec_tests(scheme, tries)
      exitstatus = 0
      try = 0
      loop do
        try += 1
        puts "Running tests (scheme: #{scheme}, try: #{try}/#{tries})"

        SimCtl.new.run_with_simulator(TEST_DEVICE, TEST_RUNTIME) do |simulator_udid|
          build_cmd = format_build_cmd('test', scheme,
                                       '-destination', "'platform=iOS Simulator,id=#{simulator_udid}'",
                                       '-enableCodeCoverage', 'YES')
          exitstatus = run(build_cmd, exit_on_failure: false)
        end

        break if exitstatus.zero?
        exit(exitstatus) if try >= tries.to_i
      end
    end

    def exec_clean(scheme)
      run format_build_cmd('clean', scheme)
    end

    def exec_build(scheme)
      run format_build_cmd('build', scheme)
    end

    def exec_analyze(scheme)
      run format_build_cmd('analyze', scheme)
    end

    def base_build_cmd(workspace = WORKSPACE, *args)
      "xcodebuild -workspace #{workspace} -sdk iphonesimulator #{args.join ' '}"
    end

    def format_build_cmd(cmd, scheme = nil, *args)
      scheme = scheme.nil? ? nil : "-scheme #{scheme}"
      cmd = base_build_cmd(WORKSPACE, cmd, scheme, args)

      if env_skip_xcpretty?
        cmd
      else
        "set -o pipefail && #{cmd} | xcpretty"
      end
    end

    include Env

  end

end
