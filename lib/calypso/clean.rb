require 'thor'
require 'date'
require_relative 'run'

module Calypso

  class Clean < Thor

    COPYRIGHT = <<EOT.freeze
//
//  Copyright © #{Date.today.year} Zalando SE. All rights reserved.
//
EOT

    desc 'all', 'Clean copyrights and auto-fix code style'
    def all
      invoke :copyrights
      Lint.new.invoke(:fix)
      invoke :ruby
      invoke :xunique
    end

    desc 'copyrights', 'Clean copyright headers'
    def copyrights
      fix_copyrights
    end

    desc 'ruby', 'Clean ruby sources'
    def ruby
      run 'rubocop -a calypso.rb lib/calypso/*.rb'
    end

    desc 'xunique', 'Run xunique on all pbxproj files'
    def xunique
      project_files = Dir['**/*.pbxproj'].select { |f| !f.include? 'Carthage' }
      project_files.each do |pbxproj|
        run("xunique --unique #{pbxproj}", exit_on_failure: false)
      end
    end

    private

    SOURCES_PATTERN = '**/*.{h,m,swift}'.freeze
    SKIP_PATTERN = %r{(^|\/)Carthage\/}

    include Run

    def fix_copyrights
      sources.each do |f|
        rewrite_copyright(f)
      end
    end

    def sources
      select_files(pattern: SOURCES_PATTERN, skip_pattern: SKIP_PATTERN)
    end

    def select_files(pattern:, skip_pattern:)
      Dir[pattern].select { |f| f !~ skip_pattern }
    end

    def rewrite_copyright(path)
      new_content = replace_copyright_header(path)

      return if new_content.empty?

      File.open(path, 'w') do |out|
        out.puts COPYRIGHT
        out.puts new_content
      end
    end

    def replace_copyright_header(path)
      new_content = []
      content_started = copyright_found = comment_found = comment_finished = false

      File.readlines(path).each do |line|
        copyright_found |= line =~ /Copyright.*Zalando/
        comment_found |= line =~ %r{^\/\/}
        comment_finished |= comment_found && line =~ /^\w*$/

        content_started |= copyright_found && comment_finished

        next unless content_started
        new_content << line
      end

      new_content
    end

  end

end
