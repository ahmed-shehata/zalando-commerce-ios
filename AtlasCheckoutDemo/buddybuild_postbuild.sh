#!/bin/sh

export GIT_REVISION_SHA=$(git rev-parse HEAD)

../calypso.rb ci notify_with_coverage
