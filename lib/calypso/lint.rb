require 'thor'
require_relative 'consts'
require_relative 'utils/run'

module Calypso

  class Lint < Thor

    desc 'check', 'Check code style violations'
    def check(dir = nil)
      dirs = dir ? [dir] : PROJECT_DIRS
      dirs.each do |d|
        run "swiftlint lint --config #{LINT_CFG} --path #{d} --quiet"
      end
    end

    desc 'fix', 'Automatically fix possible code style violations'
    def fix(dir = nil)
      dirs = dir ? [dir] : PROJECT_DIRS
      dirs.each do |d|
        run "swiftlint autocorrect --format --config #{LINT_CFG} --path #{d}"
      end
    end

    include Run

  end

end
