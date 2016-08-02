#!/bin/sh

export GIT_REVISION_SHA=$(git rev-parse HEAD)

bundle update
./calypso.rb ci pending 'Build prepared'
