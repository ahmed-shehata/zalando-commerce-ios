# Contributing

## Pull requests only

1. Push to the master branch directly is restricted.
1. Use feature branches and let people discuss changes in pull requests.
Pull requests should only be merged after all discussions have been concluded and 2 reviewers have given
theirs __approval__ (:+1:)

## Workflow

1. Create an issue and describe your idea (remember its number)
2. Create your feature branch (`git checkout -b <issue-NUMBER>`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Publish the branch (`git push origin issue-NUMBER`)
5. Create a new Pull Request

## Rules

1. Every change needs a test (fortunately [codecov.io](https://codecov.io/gh/zalando-incubator/atlas-ios) keeps code coverage metric)
1. Keep the code style by resolving SwiftLint warnings
1. Commit message must be in the following format:
```
#<issue_number>: <body>
```
