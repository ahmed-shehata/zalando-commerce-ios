Pod::Spec.new do |s|
  s.name         = 'AtlasSDK'
  s.version      = '0.1.0'
  s.summary      = 'Atlas iOS SDK for Zalando Checkout and Catalog APIs.'
  s.description  = <<-DESC
The purpose of this project is to provide seamless experience of Zalando articles checkout integration to the 3rd party iOS apps.

Our goal is to allow end developer integrate and run Zalando checkout in minutes using a few lines of code. There is an AtlasCheckout framework in place to have end-to-end solution including UI part for the checkout flow.

If you want to have a full control over the UI and manage checkout flow by yourself there is a low level AtlasSDK framework that covers all Checkout API calls and provide you high-level business objects to deal with.
                   DESC

  s.homepage     = 'https://github.bus.zalan.do/Atlas/atlas-ios'
  s.license      = { type: 'MIT', file: 'LICENSE' }

  s.author             = { 'Gleb Galkin' => 'gleb.galkin@zalando.de' }
  s.social_media_url   = 'https://www.linkedin.com/in/artdaw'

  s.platform     = :ios, '9.0'

  s.source       = { git: 'https://github.bus.zalan.do/Atlas/atlas-ios.git', tag: s.version.to_s }
  s.source_files = 'AtlasSDK', 'AtlasSDK/**/*.{h,m,swift}'
  s.resources = ['AtlasSDK/**/*.{storyboard}', 'AtlasSDK/**/Assets.xcassets']
  s.frameworks = 'Foundation'
  s.requires_arc = true
end
