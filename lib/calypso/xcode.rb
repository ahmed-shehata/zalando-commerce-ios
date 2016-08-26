require 'thor'
require_relative 'consts'
require_relative 'run'
require_relative 'env'

module Calypso

  class Xcode < Thor

    desc 'schemes', 'Shows available schemes'
    def schemes
      run base_build_cmd(WORKSPACE, '-list')
    end

    desc 'test [scheme] [tries]', "Runs tests for given scheme or #{SCHEME_UNIT_TESTS}"
    def test(scheme = SCHEME_UNIT_TESTS, tries = 1)
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

    def exec_tests(scheme, tries, platform = PLATFORM_DEFAULT)
      build_cmd = format_build_cmd('test', scheme,
                                   '-destination', "'platform=#{platform}'",
                                   '-enableCodeCoverage', 'YES')
      exitstatus = 0
      try = 0
      loop do
        try += 1
        puts "Running tests (try: #{try}/#{tries})"
        exitstatus = run(build_cmd, false)
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
      "xcodebuild -workspace #{workspace} -parallelizeTargets -sdk iphonesimulator #{args.join ' '}"
    end

    def format_build_cmd(cmd, scheme = nil, *args)
      scheme = scheme.nil? ? nil : "-scheme #{scheme}"
      cmd = base_build_cmd(WORKSPACE, cmd, scheme, args)

      if env_skip_xcpretty?
        cmd
      else
        "set -o pipefail && #{cmd} | xcpretty -f #{`xcpretty-travis-formatter`}"
      end
    end

    include Env

  end

end
