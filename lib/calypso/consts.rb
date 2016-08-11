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

  PLATFORM_DEFAULT = 'iOS Simulator,name=iPhone 6s'.freeze

  PROJECT_DIRS = [BASE_DIR + 'AtlasSDK', BASE_DIR + 'AtlasDemo'].freeze

  MIN_CODE_COVERAGE = 70
  COV_THRESHOLD_WARN = -0.5
  COV_THRESHOLD_FAIL = -3
  XCOV_JSON_REPORT = 'xcov_report/report.json'.freeze

  LINT_CFG = BASE_DIR + '.swiftlint.yml'

  COV_EXCLUDE_PRODUCTS = [PRODUCT_MOCK_SERVER, PRODUCT_CHECKOUT_DEMO].freeze

end
