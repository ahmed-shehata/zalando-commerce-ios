# Contributing

## Pull requests only

__DON'T__ push to the master branch directly. Always use feature branches and let people discuss changes in pull requests.
Pull requests should only be merged after all discussions have been concluded and 2 reviewers have given theirs __approval__.

## Workflow

1. Create an issue and describe your idea (use its number)
2. Create your feature branch (git checkout -b issue-NUMBER)
3. Commit your changes (git commit -am 'Add some feature')
4. Publish the branch (git push origin issue-NUMBER)
5. Create a new Pull Request

## Guidelines

- __every change__ needs a test
- keep the current code style powered by SwiftLint
- commit message should be in the following format:
```
#<issue_number>: <body>
```

## Development environment setup

### Requirements

- Carthage
- SwiftLint

```
brew install swiftlint carthage
gem install bundler
bundle install
```

### Start developing

```
git clone git@github.com:zalando-incubator/atlas-ios.git && cd $_
./calypso.rb deps build
open AtlasSDK.xcworkspace
```

### SwiftLint

There's `./calypso.rb lint check` for check and `./calypso.rb lint fix` to apply rules tasks manually.

The same `check` task is included into the build targets.


### Changelog generation

Sometime it is very helpful to have a full changelog.
In order to generate a new one you need to set environment variable CHANGELOG_GITHUB_TOKEN pointing
to the [GitHub access token for command-line use](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)

After that simply run `./calypso.rb docs changelog` to generate new CHANGELOG.md file.

