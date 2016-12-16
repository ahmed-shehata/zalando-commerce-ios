require 'pathname'

module Calypso

  BASE_DIR = Pathname(File.dirname(__FILE__)) + '../..'

  WORKSPACE = BASE_DIR + 'AtlasSDK.xcworkspace'

  PROJECT_MOCK_SERVER = 'AtlasMockAPI'.freeze
  PROJECT_CHECKOUT_DEMO = 'AtlasDemo'.freeze

  PRODUCT_MOCK_SERVER = "#{PROJECT_MOCK_SERVER}.framework".freeze
  PRODUCT_CHECKOUT_DEMO = "#{PROJECT_CHECKOUT_DEMO}.app".freeze

  PROJECT_PATH_SDK = BASE_DIR + 'AtlasSDK' + 'AtlasSDK.xcodeproj'
  PROJECT_PATH_CHECKOUT_DEMO = BASE_DIR + 'AtlasDemo' + 'AtlasDemo.xcodeproj'

  SCHEME_SDK = 'AtlasSDK'.freeze
  SCHEME_MOCK_SERVER = 'AtlasMockAPI'.freeze
  SCHEME_CHECKOUT = 'AtlasCheckout'.freeze
  SCHEME_CHECKOUT_DEMO = 'AtlasDemo'.freeze
  SCHEME_UNIT_TESTS = 'UnitTests'.freeze
  SCHEME_UI_UNIT_TESTS = 'UI+UnitTests'.freeze

  TEST_DEVICE = 'iPhone 7'.freeze
  TEST_RUNTIME = 'iOS 10.2'.freeze

  PROJECT_DIRS = [BASE_DIR + 'AtlasSDK', BASE_DIR + 'AtlasDemo'].freeze

  LINT_CFG = BASE_DIR + '.swiftlint.yml'

  CLEANABLE_GITHUB_PROJECT_COLUMNS = { 'Technical Debt' => ['Done'], 'Current Release' => ['Finished'] }.freeze

  VERSIONABLE_PROJECTS = %w(AtlasSDK AtlasUI AtlasDemo).freeze
  VERSIONED_PROJECT_FILES = '**/{Info.plist,project.pbxproj}'.freeze

end
