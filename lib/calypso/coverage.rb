require 'thor'
require 'xcov'
require 'json'

require_relative 'consts'
require_relative 'xcode'
require_relative 'run'

module Calypso

  class Coverage < Thor

    desc 'check [fast] [scheme]', 'Runs test coverage'
    def check(fast = nil, scheme = SCHEME_ALL_UNIT_TESTS)
      unless fast == 'fast'
        Xcode.new.invoke(:clean, [scheme])
        Xcode.new.invoke(:test, [scheme])
      end

      exec_xcov scheme
    end

    desc 'view [scheme]', 'Opens test coverage'
    def view(scheme = SCHEME_ALL_UNIT_TESTS)
      invoke :check, scheme
      run 'open xcov_report/index.html'
    end

    private

    include Run

    def exec_xcov(scheme, _workspace = WORKSPACE, _min = MIN_CODE_COVERAGE)
      last_cov = reported_coverage
      run "xcov --json_report --exclude_targets #{COV_EXCLUDE_PRODUCTS.join(',')}" \
        " -w #{WORKSPACE} -s #{scheme} 2>&1 > /dev/null"
      current_cov = reported_coverage

      change = last_cov.nil? ? 0 : current_cov - last_cov
      report = { last: last_cov, current: current_cov, change: change }

      msg = format_message(report)
      report[:msg] = msg

      report
    end

    def reported_coverage(file = XCOV_JSON_REPORT)
      return nil unless File.exist? file
      report = JSON.parse(File.read(file))
      (report['coverage'] * 1000).to_i / 10.0
    end

    def format_message(report)
      sign = report[:change] >= 0 ? '+' : ''
      "Code coverage: #{report[:current]}% (#{sign}#{report[:change]}%)"
    end

  end

end
