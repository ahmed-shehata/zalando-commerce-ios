# Contributing

## Pull requests only

1. Push to the master branch directly is restricted.
1. Use feature branches and let people discuss changes in pull requests.
1. Pull requests can only be merged after all discussions have been concluded and 2 reviewers have given
theirs approval (:+1:)

## Workflow

1. Create an issue and describe your idea (remember its number)
1. Create your feature branch: `git checkout -b <issue-NUMBER>`
1. Commit your changes: `git commit -am 'Add some feature'`
1. Publish the branch: `git push origin issue-NUMBER`
1. Create a new Pull Request

## Rules

1. Every change needs a test (fortunately [codecov.io](https://codecov.io/gh/zalando-incubator/atlas-ios) keeps code coverage metric)
1. Keep the code style by resolving SwiftLint warnings
1. Commit message must be in the following format:
```
#<issue_number>: <body>
```
