require 'thor'
require_relative '../run'

module Calypso

  class Carthage < Thor

    desc 'build', 'Builds and creates an archive'
    def build
      run 'carthage build --no-skip-current --platform iOS --no-use-binaries'
      run 'carthage archive AtlasSDK AtlasUI'
    end

    include Run

  end

end
