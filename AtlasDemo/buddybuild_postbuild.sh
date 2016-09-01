#!/usr/bin/env bash

cd ..
bash <(curl -s https://codecov.io/bash) -J AtlasSDK -J AtlasUI -D /private/tmp/sandbox/${BUDDYBUILD_APP_ID}/bbtest -Z -K -B ${BUDDYBUILD_BRANCH} -b ${BUDDYBUILD_BUILD_NUMBER}

# find / -type f -name '*.profdata' 2> /dev/null
