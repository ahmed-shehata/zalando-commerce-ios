require 'pathname'

module Calypso

  BASE_DIR = Pathname(File.dirname(__FILE__)) + '../..'

  WORKSPACE = BASE_DIR + 'AtlasSDK.xcworkspace'

  SCHEME_UNIT_TESTS = 'UnitTests'.freeze
  SCHEME_UI_UNIT_TESTS = 'UI+UnitTests'.freeze

  TEST_DEVICE = 'iPhone.*[0-9]+\w?$'.freeze # finds potentially the newest device to run
  TEST_RUNTIME = 'iOS'.freeze # finds newest iOS

  PROJECT_DIRS = [BASE_DIR + 'AtlasSDK', BASE_DIR + 'AtlasUI'].freeze

  LINT_CFG = BASE_DIR + '.swiftlint.yml'

  CLEANABLE_GITHUB_PROJECT_COLUMNS = { 'Technical Debt' => ['Done'], 'Current Release' => ['Finished'] }.freeze

  VERSIONABLE_PROJECTS = %w(AtlasSDK AtlasUI AtlasDemo).freeze
  VERSIONED_PROJECT_FILES = '**/{Info.plist,project.pbxproj}'.freeze

end
