require 'thor'
require 'pathname'
require_relative '../utils/run'
require_relative '../utils/log'
require_relative '../utils/git_cmd'
require_relative '../../version'

module Calypso

  class Docs < Thor

    SOURCE_FOLDER = Pathname.new File.expand_path('../../../..', __FILE__).freeze
    DOCS_FOLDER = Pathname.new File.expand_path('../../../../docs', __FILE__).freeze

    MODULES = {
      'AtlasSDK' => 'atlas-sdk',
      'AtlasUI' => 'atlas-ui'
    }.freeze

    desc 'publish', 'Regenerate docs and push them to the repository'
    option :docs, type: :boolean, default: true,
                  desc: 'Runs "generate" before. Turn it off if you want to publish only.'
    def publish
      invoke :generate if options[:docs]
      publish_docs
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
        'theme' => 'fullwidth',
        'readme' => SOURCE_FOLDER + 'README.md',
        'clean' => true, 'hide-documentation-coverage' => false, 'objc' => false,
        'module' => src, 'module-version' => ATLAS_VERSION,
        'author' => 'Zalando SE', 'author_url' => 'http://tech.zalando.com',
        'github_url' => 'https://github.com/zalando-incubator/atlas-ios',
        'copyright' => '© 2016-2017 [Zalando SE](http://tech.zalando.com)'
      }

      source_dir = SOURCE_FOLDER + src # can't use "--source-directory", as it picks up wrong podspec
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
      (DOCS_FOLDER + dst).to_s
    end

    def publish_docs
      log 'Publishing docs...'
      repo.add DOCS_FOLDER.to_s
      repo.commit '[auto] Updated docs'
      repo.push
    rescue StandardError => e
      log_abort e
    end

    include Log
    include Run
    include GitCmd

  end

end
