require_relative './lib/version.rb'

Pod::Spec.new do |spec|
  spec.name = 'MockAPI'
  spec.platform = :ios, '9.0'
  spec.version = ZC_VERSION
  spec.summary = 'Zalando Commenrce SDK iOS Mock API server'
  spec.homepage = 'https://github.com/zalando-incubator/zalando-commerce-ios'

  spec.description = <<-DESC
  Internal podspec for mock service. Please don't publish.
  DESC

  spec.license = {
    type: 'MIT',
    file: 'LICENSE'
  }

  spec.authors = {
    'Ahmed Shehata' => 'ahmed.shehata@zalando.de',
    'Daniel Bauke' => 'daniel.bauke@zalando.de',
    'Gleb Galkin' => 'gleb.galkin@zalando.de',
    'Haldun Bayhantopcu' => 'haldun.bayhantopcu@zalando.de',
    'Hani Ibrahim' => 'hani.eloksh@zalando.de'
  }

  spec.source = {
    git: 'https://github.com/zalando-incubator/zalando-commerce-ios.git',
    tag: spec.version.to_s
  }

  spec.source_files = 'Sources/MockAPI/MockAPI/**/*.swift'
  spec.ios.frameworks = 'Foundation'
  spec.ios.resources = ['Sources/MockAPI/MockAPI/**/*.json']

  spec.dependency 'Swifter'
  spec.dependency 'Freddy'
end
