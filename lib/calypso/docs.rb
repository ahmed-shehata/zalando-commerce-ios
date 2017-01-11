require 'thor'
require 'pathname'
require_relative 'run'
require_relative 'log'

module Calypso

  class Docs < Thor

    SOURCE_FOLDER = Pathname.new File.expand_path('../../..', __FILE__).freeze
    DESTINATION_FOLDER = Pathname.new File.expand_path('../../../docs', __FILE__).freeze

    desc 'generate', 'Generate code documentation in docs folder'
    def generate
      generate_docs('AtlasSDK', 'atlas-sdk')
      generate_docs('AtlasUI', 'atlas-ui')
    end

    private

    def generate_docs(src, dst)
      args = {
        'output' => DESTINATION_FOLDER + dst,
        'copyright' => '© 2016-2017 [Zalando SE](http://tech.zalando.com)',
        'clean' => true,
        'hide-documentation-coverage' => false,
        'objc' => false,
        'theme' => 'apple',
        'github_url' => 'https://github.com/zalando-incubator/atlas-ios'
      }

      source = SOURCE_FOLDER + src
      run "cd #{source} && jazzy #{parse_args(args)}"
    end

    def parse_args(args)
      args.map do |k, v|
        if v == false
          "--no-#{k}"
        elsif v == true
          "--#{k}"
        else
          "--#{k} '#{v}'"
        end
      end.join ' '
    end

    include Log
    include Run

  end

end
