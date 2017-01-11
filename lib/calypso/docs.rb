require 'thor'
require 'pathname'
require_relative 'run'
require_relative 'log'
require_relative '../version'

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
        'theme' => 'apple',
        'clean' => true, 'hide-documentation-coverage' => false, 'objc' => false,
        'module' => src, 'module-version' => ATLAS_VERSION,
        'author' => 'Zalando SE', 'author_url' => 'http://tech.zalando.com',
        'github_url' => 'https://github.com/zalando-incubator/atlas-ios',
        'copyright' => '© 2016-2017 [Zalando SE](http://tech.zalando.com)'
      }

      source_dir = SOURCE_FOLDER + src # --source-directory pick ups podspec
      run "cd #{source_dir} && jazzy #{parse_args(args)}"
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
