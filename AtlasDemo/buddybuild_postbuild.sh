#!/usr/bin/env bash

cd ..

git describe --tags --exact-match > /dev/null 2> /dev/null
if [[ $? -eq 0 ]]; then
	echo Verifying pods
	pod repo update 2> /dev/null
	pod lib lint AtlasSDK.podspec --allow-warnings
	pod lib lint AtlasUI.podspec --allow-warnings
fi

cd AtlasDemo
./testdroid_upload.sh
