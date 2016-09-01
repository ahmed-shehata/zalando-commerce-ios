# Contributing

## Pull requests only

__DON'T__ push to the master branch directly. Always use feature branches and
let people discuss changes in pull requests.  Pull requests should only be
merged after all discussions have been concluded and 2 reviewers have given
theirs __approval__ (:+1:).

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

### Swiss-knife script

To avoid repeating or remembering common tasks in the project,
[Calypso](https://en.wikipedia.org/wiki/Calypso_(mythology)) was born.

Anything which could be useful (or not) is kept and should be added there.

### Requirements

- SwiftLint

To setup required tools, just run:

```
brew install swiftlint
gem install bundler
```

### Coding

To start coding and compiling, just run:

```
git clone git@github.com:zalando-incubator/atlas-ios.git && cd $_
bundle install
open AtlasSDK.xcworkspace
```

### Adding external libraries

Main frameworks (AtlasSDK and AtlasUI) **cannot** depend on any external library.

However, in some cases it's useful to use them in some satelite projects
(AtlasMockAPI or AtlasDemo).  For this purpose we use Carthage. `calypso.rb`
has appropriate task for it:

```
brew install carthage
./calypso.rb deps build
```

### SwiftLint

There's `./calypso.rb lint check` for check and `./calypso.rb lint fix` to
apply rules tasks manually.

The same `check` task is included into the build targets.

### ZenHub

We use [ZenHub](https://www.zenhub.com/), a project management tool on a top of
GitHub, you can easily install as a browser extension and use it.

### Changelog generation

Sometime it is very helpful to have a full changelog.
In order to generate a new one you need to set environment variable `CHANGELOG_GITHUB_TOKEN` pointing
to the [GitHub access token for command-line use](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)

After that simply run `./calypso.rb docs changelog` to generate new CHANGELOG.md file.
