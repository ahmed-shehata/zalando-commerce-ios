require_relative './lib/version.rb'

# rubocop:disable Metrics/BlockLength
Pod::Spec.new do |spec|
  spec.name = 'ZalandoCommerceAPI'
  spec.platform = :ios, '9.0'
  spec.version = ZC_VERSION
  spec.summary = 'Low-level SDK with API client and models for Zalando Checkout and Catalog APIs.'
  spec.homepage = 'https://github.com/zalando-incubator/atlas-ios'

  spec.description = <<-DESC
The purpose of this project is to provide seamless experience of Zalando
articles checkout integration to the 3rd party iOS apps.

Our goal is to allow end developer integrate and run Zalando checkout in
minutes using a few lines of code. There is an AtlasCheckout framework in place
to have end-to-end solution including UI part for the checkout flow.

If you want to have a full control over the UI and manage checkout flow by
yourself please use this low-level ZalandoCommerceAPI framework that covers all Checkout
API calls and provide you high-level business objects to deal with.
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
    git: 'https://github.com/zalando-incubator/atlas-ios.git',
    tag: spec.version.to_s
  }

  spec.source_files = 'Sources/ZalandoCommerceAPI/ZalandoCommerceAPI/**/*.swift', \
                      'Sources/Commons/*.swift'
  spec.ios.frameworks = 'Foundation'
end
