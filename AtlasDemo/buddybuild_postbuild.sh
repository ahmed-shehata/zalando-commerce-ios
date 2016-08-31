#!/usr/bin/env bash

# cd ..
bash <(curl -s https://codecov.io/bash) -J AtlasSDK -J AtlasUI

echo "=== Project structure"
find .. -type d

echo "=== VM Structure"
find / -type d

