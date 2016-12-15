#!/usr/bin/env bash

cd ..
echo PWD: $PWD

bundle install
bundle exec ./calypso.rb pod validate --local

