#!/usr/bin/env bash

#  Created by Hilary Chukwuji on 12/09/16.
#  Copyright (c) 2016 Honza Dvorsky. All rights reserved.

cd ..
pod lib lint AtlasSDK.podspec --allow-warnings
./testdroid_upload.sh
