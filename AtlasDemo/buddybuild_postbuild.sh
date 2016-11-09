#!/usr/bin/env bash

#  Created by Hilary Chukwuji on 12/09/16.
#  Copyright (c) 2016 Honza Dvorsky. All rights reserved.

cd ..
# bash <(curl -s https://codecov.io/bash) -J AtlasSDK -J AtlasUI -D /private/tmp/sandbox/${BUDDYBUILD_APP_ID}/bbtest -Z -K

# if [[ $BUDDYBUILD_BRANCH == "master" ]]; then

if [ -z ${API_ENDPOINT} ]; then
  API_ENDPOINT=https://cloud.testdroid.com
fi

# if [ -z "$1" ]; then
#   read -p "Testdroid API-Key: " TESTDROID_APIKEY
# else
#   TESTDROID_APIKEY=$1
# fi

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


# Check that the used project is of correct type 
PROJECT_TYPE="$(curl -s -H "Accept: application/json" -u ${TESTDROID_APIKEY}: "${API_ENDPOINT}/api/v2/me/projects/${TESTDROID_PROJECT_ID}" | python -m json.tool | sed -n -e '/"type":/ s/^.*"type": "\(.*\)".*/\1/p')"
echo "PROJECT_TYPE: ${PROJECT_TYPE}"
PROJECT_FRAMEWORK="$(curl -s -H "Accept: application/json" -u ${TESTDROID_APIKEY}: "${API_ENDPOINT}/api/v2/me/projects/${TESTDROID_PROJECT_ID}" | python -m json.tool | sed -n -e '/"frameworkId":/ s/^.* \(.*\),.*/\1/p')"
echo "PROJECT_FRAMEWORK: ${PROJECT_FRAMEWORK}"


if [[  ${PROJECT_TYPE} = "IOS" || ( ${PROJECT_TYPE} = "APPIUM_IOS_SERVER_SIDE" ) ]] ; then
  :
  else
  echo "PROJECT_TYPE: ${PROJECT_TYPE} is not correct exiting"
exit
fi 



if [ -z "$DEVICE_GROUP_NAME" ]; then
  DEVICE_GROUP_NAME=larry-iOS-device-group
  
fi
# Check that Device Group exists
echo "DEVICE_GROUP_NAME: ${DEVICE_GROUP_NAME}"
DEVICE_GROUP_ID="$(curl -G -s -H "Accept: application/json" -u ${TESTDROID_APIKEY}: "${API_ENDPOINT}/api/v2/me/device-groups?withPublic=true" --data-urlencode "limit=1" --data-urlencode "search=${DEVICE_GROUP_NAME}" | python -m json.tool | sed -n -e '/"id":/ s/^.* \(.*\),.*/\1/p')"
echo "DEVICE_GROUP_ID: ${DEVICE_GROUP_ID}"

if [ -z ${DEVICE_GROUP_ID} ]; then
    echo "No DEVICE_GROUP_ID found; Device group with name \"${DEVICE_GROUP_NAME}\" doesn't seem to exist."
    exit
fi


# Check that Device Group is of correct type
DEVICE_GROUP_TYPE="$(curl -s -H "Accept: application/json" -u ${TESTDROID_APIKEY}: "${API_ENDPOINT}/api/v2/me/device-groups/${DEVICE_GROUP_ID}" | python -m json.tool | sed -n -e '/"osType":/ s/^.*"osType": "\(.*\)".*/\1/p')"
echo "DEVICE_GROUP_TYPE: ${DEVICE_GROUP_TYPE}"


if [[ ( ${DEVICE_GROUP_TYPE} != "IOS" ) ]] ; then
     echo "Mismatch: Device Group type and Project Type/OS does not match: DEVICE_GROUP_TYPE:${DEVICE_GROUP_TYPE}  exiting...."
    exit
   
fi

#curl \
  #-F "file=@$BUDDYBUILD_IPA_PATH" \
  #-F "build_number=$BUDDYBUILD_BUILD_NUMBER"
echo "Uploading IPA file this might take some minutes"
curl -H "Accept: application/json" -u ${TESTDROID_APIKEY}: -X POST -F "file=@${APP_FILE}" "${API_ENDPOINT}/api/v2/me/projects/${TESTDROID_PROJECT_ID}/files/application"


echo "Uploaded IPA file successfully"


#Create test run

# Test run
echo "launching test"
TESTRUN_ID="$(curl -s -H "Accept: application/json" -u ${TESTDROID_APIKEY}: -X POST "${API_ENDPOINT}/api/v2/me/projects/${TESTDROID_PROJECT_ID}/runs?usedDeviceGroupId=${DEVICE_GROUP_ID}" | python -m json.tool | sed -n -e '/"id":/ s/^.* \(.*\),.*/\1/p')"
if [ -z ${TESTRUN_ID} ] ; then

echo "TESTRUN_ID is not gotten. The Test did not start exiting...."

exit

else
echo "Test run ID: ${TESTRUN_ID}"

    TEST_STATE="WAITING"
    while [ ${TEST_STATE} != "\"FINISHED\"" ] ; do
        TEST_STATE="$(curl -s -H "Accept: application/json" -u ${TESTDROID_APIKEY}: "${API_ENDPOINT}/api/v2/me/projects/${TESTDROID_PROJECT_ID}/runs/${TESTRUN_ID}" | python -m json.tool | sed -n -e '/"state":/ s/^.* \(.*\),.*/\1/p')"
        echo "TEST_STATE = ${TEST_STATE}"
        sleep 10
    done
fi

#Get Sumary of test run

#TESTREPORT="$(curl -H "Accept: application/json" -X GET -u ${TESTDROID_APIKEY}: "${API_ENDPOINT}/api/v2/me/projects/${TESTDROID_PROJECT_ID}/runs/${TESTRUN_ID}/reports/summary?type=HTML")"

#echo "Test report: ${TESTREPORT}"


#curl -s -H "Accept: application/json" -u 0WD5ezcDOJpWDtXECDgzjCQ6nMDalKoB: -X POST "https://cloud.testdroid.com/api/v2/me/projects/99662668/#runs/102548081/abort"

# fi

