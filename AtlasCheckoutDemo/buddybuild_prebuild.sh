#!/bin/sh

export GIT_REVISION_SHA=$(git rev-parse HEAD)

../calypso.rb ci pending 'Build started'
