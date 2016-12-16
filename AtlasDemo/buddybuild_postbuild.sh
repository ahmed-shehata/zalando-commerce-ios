#!/usr/bin/env bash

cd ..

ruby -v
bundle update
bundle exec ./calypso.rb pod validate --local

