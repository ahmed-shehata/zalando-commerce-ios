require 'thor'
require_relative 'consts'
require_relative 'run'

module Calypso

  class Xcode < Thor

    desc 'schemes', 'Shows available schemes'
    def schemes
      run base_build_cmd(WORKSPACE, '-list')
    end

    desc 'test [scheme]', "Runs tests for given scheme or #{SCHEME_ALL_TESTS}"
    def test(scheme = SCHEME_ALL_TESTS)
      exec_tests scheme
    end

    desc 'build [scheme]', 'Builds given scheme'
    def build(scheme = SCHEME_ALL_TESTS)
      exec_build scheme
    end

    desc 'analyze [scheme]', 'Analyzes given scheme'
    def analyze(scheme = SCHEME_ALL_TESTS)
      exec_analyze scheme
    end

    desc 'clean [scheme]', 'Cleans given scheme'
    def clean(scheme = SCHEME_ALL_TESTS)
      exec_clean scheme
    end

    private

    include Run

    def exec_tests(scheme, platform = PLATFORM_DEFAULT)
      run format_build_cmd('test', scheme,
                           '-destination', "'platform=#{platform}'",
                           '-enableCodeCoverage', 'YES')
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

      "set -o pipefail && #{cmd} | xcpretty"
    end

  end

end
