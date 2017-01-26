#!/usr/bin/env bash

rm -rf AtlasDemo/Podfile
rm -rf Cartfile.private

# TODO:
# 1. merge from master
# 2. replace sed on swift source to sed on Info.plist file

sed -i ''  's#NSProcessInfo.*"USE_MOCK_API".*#true#' AtlasDemo/AtlasDemo/AppSetup.swift
