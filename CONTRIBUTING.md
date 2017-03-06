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

## External libraries

Main frameworks (_AtlasSDK_ and _AtlasUI_) have strict rule to **do not depend
on any external library**.  In exceptional cases it could be lifted, but still
you should first consider taking source code from the external framework
instead (and the best – not whole, but just needed part).

Rationale behind is:

1. Don't force end-developers to use additional libraries. It makes their app
   fatter and harder to maintain, as it could also lead to conflicts with their
   own dependencies
1. A small piece of code which does the job well is easier in maintenance than
   coupling to external library, which could change a lot
1. Not updated library may introduce risk of having it not fixed or updated if
   it loose a maintainer
1. Updating unmaintained the whole external library (eg. for new Swift version)
   on your own could be time consuming
1. And in general, not only on framework level: the less dependencies, the higher
   reuse factor.


They're totally allowed in satellite projects (_MockAPI_ or _AtlasDemo_), however the less we have them,
the simpler maintanance and updating is.

For this purpose we use Carthage. `calypso.rb` has an appropriate task for it:

```
brew install carthage
./calypso.rb deps build
```

