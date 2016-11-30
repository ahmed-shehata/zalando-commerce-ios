require_relative './lib/version'

# rubocop:disable Metrics/BlockLength
Pod::Spec.new do |s|
  s.name = 'AtlasSDK'
  s.platform = :ios, '9.0'
  s.version = ATLAS_VERSION
  s.summary = 'Atlas iOS SDK for Zalando Checkout and Catalog APIs.'
  s.homepage = 'https://github.com/zalando-incubator/atlas-ios'

  s.description = <<-DESC
The purpose of this project is to provide seamless experience of Zalando
articles checkout integration to the 3rd party iOS apps.

Our goal is to allow end developer integrate and run Zalando checkout in
minutes using a few lines of code. There is an AtlasCheckout framework in place
to have end-to-end solution including UI part for the checkout flow.

If you want to have a full control over the UI and manage checkout flow by
yourself there is a low level AtlasSDK framework that covers all Checkout API
calls and provide you high-level business objects to deal with.
  DESC
  s.license = {
    type: 'MIT',
    file: 'LICENSE'
  }
  s.authors = {
    'Ahmed Shehata' => 'ahmed.shehata@zalando.de',
    'Daniel Bauke' => 'daniel.bauke@zalando.de',
    'Gleb Galkin' => 'gleb.galkin@zalando.de',
    'Haldun Bayhantopcu' => 'haldun.bayhantopcu@zalando.de',
    'Hani Ibrahim' => 'hani.eloksh@zalando.de'
  }
  s.source = {
    git: 'https://github.com/zalando-incubator/atlas-ios.git',
    tag: s.version.to_s
  }

  s.subspec 'Core' do |ss|
    ss.source_files = 'AtlasSDK/AtlasSDK/**/*.{h,m,swift}'
    ss.frameworks = 'Foundation'
  end

  s.subspec 'UI' do |ss|
    ss.dependency 'AtlasSDK/Core'
    ss.source_files = 'AtlasUI/AtlasUI/**/*.{h,m,swift}'
    ss.ios.resource_bundle = {
      'AtlasUI' => ['AtlasUI/AtlasUI/**/*.xcassets', 'AtlasUI/AtlasUI/**/Localizable.strings']
    }
    ss.frameworks = 'Foundation', 'UIKit'
  end

  s.default_subspecs = 'Core', 'UI'
end
