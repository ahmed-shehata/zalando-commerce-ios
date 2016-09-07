require 'thor'
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
      invoke :fix_ruby
      invoke :xunique
    end

    desc 'copyrights', 'Clean copyright headers'
    def copyrights
      clean_files('**/*.{h,m,swift}', %r{\/Carthage\/})
    end

    desc 'fix_ruby', 'Clean ruby sources'
    def fix_ruby
      run 'rubocop -a calypso.rb lib/calypso/*.rb'
    end

    desc 'xunique', 'Run xunique on all pbxproj files'
    def xunique
      project_files = Dir['**/*.pbxproj'].select { |f| !f.include? 'Carthage' }
      project_files.each do |pbxproj|
        run("xunique -p #{pbxproj}", false)
      end
    end

    private

    include Run

    def clean_files(pattern, skip_pattern = nil)
      Dir[pattern].each do |f|
        next if f =~ skip_pattern
        rewrite_file(f)
      end
    end

    def rewrite_file(path)
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
