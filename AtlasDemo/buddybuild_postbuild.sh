#!/usr/bin/env bash

cd ..
echo PWD: $PWD
bundle exec ./calypso.rb pod validate --local

