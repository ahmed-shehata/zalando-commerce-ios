require 'thor'
require 'pathname'
require_relative '../utils/run'
require_relative '../utils/log'
require_relative '../utils/git'
require_relative '../../version'

module Calypso

  class Docs < Thor

    SOURCE_FOLDER = Pathname.new File.expand_path('../../..', __FILE__).freeze
    DESTINATION_FOLDER = Pathname.new File.expand_path('../../../docs', __FILE__).freeze

    MODULES = {
      'AtlasSDK' => 'atlas-sdk',
      'AtlasUI' => 'atlas-ui'
    }.freeze

    desc 'publish', 'Generate docs and push them to the repository'
    def publish
      invoke :generate
    end

    desc 'generate', 'Generate code documentation in docs folder'
    def generate
      MODULES.each do |src, dst|
        generate_docs(src, dst)
      end
    end

    private

    def generate_docs(src, dst)
      args = {
        'output' => destination_path(dst),
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

    def destination_path(dst)
      DESTINATION_FOLDER + dst
    end

    def commit_docs
      MODULES.each do |_, dst|
        repo.add destination_path(dst)
      end
      repo.commit '[auto] Updated docs'
      repo.push
    rescue StandardError => e
      log_abort e
    end

    include Log
    include Run
    include Git

  end

end
