#!/usr/bin/env bash

bash <(curl -s https://codecov.io/bash) -J AtlasSDK -J AtlasUI -D /tmp/sandbox/${BUDDYBUILD_APP_ID}/bbbuild
