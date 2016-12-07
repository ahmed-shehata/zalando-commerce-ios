require 'thor'
require_relative 'consts'
require_relative 'run'

module Calypso

  class Lint < Thor

    desc 'check', 'Check code style violations'
    def check(dir = nil)
      dirs = dir ? [dir] : PROJECT_DIRS
      dirs.each do |d|
        run "swiftlint lint --config #{LINT_CFG} --path #{d} 2> /dev/null"
      end
    end

    desc 'fix', 'Automatically fix possible code style violations'
    def fix(dir = nil)
      dirs = dir ? [dir] : PROJECT_DIRS
      dirs.each do |d|
        run "swiftlint autocorrect --config #{LINT_CFG} --path #{d} > /dev/null"
      end
    end

    include Run

  end

end
