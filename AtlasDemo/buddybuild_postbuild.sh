#!/usr/bin/env bash

cd ..
pod repo update
pod lib lint AtlasSDK.podspec --allow-warnings
pod lib lint AtlasUI.podspec --allow-warnings
cd AtlasDemo
./testdroid_upload.sh
