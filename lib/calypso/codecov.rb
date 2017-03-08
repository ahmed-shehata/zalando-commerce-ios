require 'thor'
require_relative 'utils/run'
require_relative 'consts'

module Calypso

  class Codecov < Thor

    PACKAGES = %w(ZalandoCommerceAPI ZalandoCommerceUI).freeze

    desc 'upload', 'Upload reports to codecov.io'
    def upload
      packages_arg = PACKAGES.map { |p| "-J \'^#{p}$\'" }.join(' ')
      run "bash -c 'bash <(curl -s https://codecov.io/bash) #{packages_arg}'"
    end

    include Run

  end

end
