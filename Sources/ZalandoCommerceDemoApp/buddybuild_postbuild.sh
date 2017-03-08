#!/usr/bin/env bash

lint_pods_in_tagged_branch() {
    git describe --tags --exact-match > /dev/null 2> /dev/null
    if [[ $? -eq 0 ]]; then
        echo Verifying pods
        pod repo update 2> /dev/null
        pod lib lint ZalandoCommerceAPI.podspec --allow-warnings
        pod lib lint ZalandoCommerceUI.podspec --allow-warnings
    fi
}

upload_testdroid() {
    cd Sources/ZalandoCommerceDemoAppUITests
    ./testdroid_upload.sh
}

cd ../..
lint_pods_in_tagged_branch
# upload_testdroid
