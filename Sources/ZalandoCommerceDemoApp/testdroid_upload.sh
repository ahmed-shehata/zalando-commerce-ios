#!/usr/bin/env bash

#  Created by Hilary Chukwuji on 12/09/16.
#  Copyright (c) 2016 Honza Dvorsky. All rights reserved.

if [ -z ${API_ENDPOINT} ]; then
  API_ENDPOINT=https://cloud.testdroid.com
fi

if [ -z "$1" ]; then
  read -p "Testdroid API-Key: " TESTDROID_APIKEY
else
  TESTDROID_APIKEY=$1
fi

if [ -z ${TESTDROID_PROJECT_ID} ]; then
  echo "Project ID not found"
  exit
fi

if [ -z ${APP_FILE} ]; then
  APP_FILE=$BUDDYBUILD_IPA_PATH
fi

#if [ -z "$BUILD_NUMBER" ]; then
#BUILD_NUMBER=build_number
#fi

if [ -z "$DEVICE_GROUP_NAME" ]; then
  DEVICE_GROUP_NAME=iOS-tip-device1
fi

#curl \
  #-F "file=@$BUDDYBUILD_IPA_PATH" \
  #-F "build_number=$BUDDYBUILD_BUILD_NUMBER"

# Check that Device Group exists
echo "DEVICE_GROUP_NAME: ${DEVICE_GROUP_NAME}"
DEVICE_GROUP_ID="$(curl -G -s -H "Accept: application/json" -u ${TESTDROID_APIKEY}: "${API_ENDPOINT}/api/v2/me/device-groups?withPublic=true" --data-urlencode "limit=1" --data-urlencode "search=${DEVICE_GROUP_NAME}" | python -m json.tool | sed -n -e '/"id":/ s/^.* \(.*\),.*/\1/p')"
echo "DEVICE_GROUP_ID: ${DEVICE_GROUP_ID}"

if [ -z ${DEVICE_GROUP_ID} ]; then
  echo "No DEVICE_GROUP_ID found; Device group with name \"${DEVICE_GROUP_NAME}\" doesn't seem to exist."
  exit
fi

curl -H "Accept: application/json" -u ${TESTDROID_APIKEY}: -X POST -F "file=@${APP_FILE}" "${API_ENDPOINT}/api/v2/me/projects/${TESTDROID_PROJECT_ID}/files/application"


echo "Uploaded IPA file"


#Create test run

# Test run
echo "launching test"


TESTRUN_ID="$(curl -s -H "Accept: application/json" -u ${TESTDROID_APIKEY}: -X POST "${API_ENDPOINT}/api/v2/me/projects/${TESTDROID_PROJECT_ID}/runs/?usedDeviceGroupId=${DEVICE_GROUP_ID}" | python -m json.tool | sed -n -e '/"id":/ s/^.* \(.*\),.*/\1/p')"


echo "Test run ID: ${TESTRUN_ID}"

finished=false
while !finished ; do
  status=$(curl -H "Accept: application/json" -X GET -u ${TESTDROID_APIKEY}: "${API_ENDPOINT}/api/v2/me/projects/${TESTDROID_PROJECT_ID}/runs/102591705" | jq .state)
  if [[ $status = "FINISHED" ]]; then
    finished=true
  fi
  sleep 15
done

#Get Sumary of test run

TESTREPORT="$(curl -H "Accept: application/json" -X GET -u ${TESTDROID_APIKEY}: "${API_ENDPOINT}/api/v2/me/projects/${TESTDROID_PROJECT_ID}/runs/${TESTRUN_ID}/reports/summary?type=HTML")"

echo "Test report: ${TESTREPORT}"


#curl -s -H "Accept: application/json" -u 0WD5ezcDOJpWDtXECDgzjCQ6nMDalKoB: -X POST "https://cloud.testdroid.com/api/v2/me/projects/99662668/#runs/102548081/abort"

# fi

