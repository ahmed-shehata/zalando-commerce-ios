#!/usr/bin/env bash

#  Created by Hilary Chukwuji on 12/09/16.
#  Copyright (c) 2016 Honza Dvorsky. All rights reserved.


DEVICE_GROUP_NAME=4-iOSXCUITest-Device

if [ -z ${API_ENDPOINT} ]; then
  API_ENDPOINT=https://cloud.testdroid.com
fi

if [ -z "${TESTDROID_APIKEY}" ]; then
  echo "Testdroid TESTDROID_APIKEY is not given exiting"
  exit
else
else
    MAIN_USER_ID="$(curl -H "Accept: application/json" -u ${TESTDROID_APIKEY}: "${API_ENDPOINT}/api/v2/me" | python -m json.tool | sed -n -e '/"mainUserId": / s/^.*"mainUserId": \(.*\)"*,/\1/p')"
        echo "MAIN_USER_ID: ${MAIN_USER_ID}"
    if [ -z ${MAIN_USER_ID} ] ; then
        echo "Authentication failed, check apikey given in -k: "${TESTDROID_APIKEY}""
        help
    else
        echo "Authentication succeeded."
        echo "mainUserId: ${MAIN_USER_ID}"
    fi
fi

#check if project ID is found else create a new project
if [ -z ${TESTDROID_PROJECT_ID} ]; then
  echo "Project ID not found creating a new XCUITest project"
  PROJECT_NAME="$(curl -H "Accept: application/json" -u ${TESTDROID_APIKEY}: -X POST -F 'type=XCUITEST' "${API_ENDPOINT}/api/v2/me/projects" | python -m json.tool | sed -n -e '/"name":/ s/^.*"name": "\(.*\)".*/\1/p')"

  TESTDROID_PROJECT_ID="$(curl -s -H "Accept: application/json" -u ${TESTDROID_APIKEY}: "${API_ENDPOINT}/api/v2/me/projects?limit=1" --data-urlencode "search=${PROJECT_NAME}" | python -m json.tool | sed -n -e '/"id":/ s/^.* \(.*\),.*/\1/p')"
      echo "Project created with ID: ${TESTDROID_PROJECT_ID} and name: ${PROJECT_NAME}"
      if [ -z {PROJECT_NAME}] ; then
         echo "No Project created"
         exit

      fi

else
echo "Project found with ID: ${TESTDROID_PROJECT_ID}"

fi

#checking the .ipa file
if [ -z ${APP_FILE} ]; then
  APP_FILE=$BUDDYBUILD_IPA_PATH
fi

#checking the -Runner.app folder
if [ -z ${RUNNER_FOLDER} ]; then
  RUNNER_FOLDER=$BUDDYBUILD_TEST_DIR
fi


# Check that the used project is of correct type
PROJECT_TYPE="$(curl -s -H "Accept: application/json" -u ${TESTDROID_APIKEY}: "${API_ENDPOINT}/api/v2/me/projects/${TESTDROID_PROJECT_ID}" | python -m json.tool | sed -n -e '/"type":/ s/^.*"type": "\(.*\)".*/\1/p')"
echo "PROJECT_TYPE: ${PROJECT_TYPE}"

if [ "${PROJECT_TYPE}" == "XCUITEST" ] ; then

        #Check if framework of correct type
        PROJECT_FRAMEWORK_ID="$(curl -s -H "Accept: application/json" -u ${TESTDROID_APIKEY}: "${API_ENDPOINT}/api/v2/me/projects/${TESTDROID_PROJECT_ID}" | python -m json.tool | sed -n -e '/"frameworkId":/ s/^.* \(.*\),.*/\1/p')"
        echo "PROJECT_FRAMEWORK_ID: ${PROJECT_FRAMEWORK_ID}"

        if [ ${PROJECT_FRAMEWORK_ID} != 612 ]; then

        echo "The framework type is wrong"
        exit
        fi
else
    echo "wrong Project type: ${PROJECT_TYPE} "
exit

fi


#Check the device-groups exists
if [ -z "$DEVICE_GROUP_NAME" ]; then
  echo  "Please provide device group with correct platform (device OS) using the -g flag exiting....."
  exit

fi


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

if [ "${DEVICE_GROUP_TYPE}" != "IOS" ] ; then

    echo "Device Group must be iOS device exiting...."
    exit

fi

#curl \
  #-F "file=@$BUDDYBUILD_IPA_PATH" \
  #-F "build_number=$BUDDYBUILD_BUILD_NUMBER"

echo "Uploading IPA file it may take some time"
curl -H "Accept: application/json" -u ${TESTDROID_APIKEY}: -X POST -F "file=@${APP_FILE}" "${API_ENDPOINT}/api/v2/me/projects/${TESTDROID_PROJECT_ID}/files/application"
echo "Uploaded IPA file"

#zip and upload the RUNNER_FOLDER
echo Zipping the RUNNER_FOLDER
echo "RUNNER_FOLDER is: ${RUNNER_FOLDER}"
echo "Zipping RUNNER_FOLDER: ${RUNNER_FOLDER}"
zip -r -X Atlas-Runner.zip $RUNNER_FOLDER

if [ -z ${Atlas-Runner.zip} ] ; then
  echo "App folder was not zipped exiting"
  exit
else
RUNNER_ZIP=Atlas-Runner.zip
echo "ZIP_FOLDER is: ${RUNNER_ZIP}"
fi
echo "Uploading ${RUNNER_ZIP} to Project with ID ${TESTDROID_PROJECT_ID} this may take some minutes"
curl -H "Accept: application/json" -u ${TESTDROID_APIKEY}: -X POST -F "file=@${RUNNER_ZIP}" "${API_ENDPOINT}/api/v2/me/projects/${TESTDROID_PROJECT_ID}/files/test"
echo " zip folder: ${RUNNER_ZIP} was uploaded successfully "


#Create test run
echo "launching XCUITEST"
TESTRUN_ID="$(curl -s -H "Accept: application/json" -u ${TESTDROID_APIKEY}: -X POST "${API_ENDPOINT}/api/v2/me/projects/${TESTDROID_PROJECT_ID}/runs/?usedDeviceGroupId=${DEVICE_GROUP_ID}" | python -m json.tool | sed -n -e '/"id":/ s/^.* \(.*\),.*/\1/p')"
echo "Test run ID: ${TESTRUN_ID}"

if [ -z ${TESTRUN_ID} ] ; then
    echo "TESTRUN_ID not gotten, the test probably wasn't launched properly.. exiting."
    exit
else
    echo "Testrun ID: ${TESTRUN_ID}"

fi

# Replace 'com/cloud' with 'com' from the end, if it exists due to private cloud API endpoint.
API_ENDPOINT=${API_ENDPOINT//com\/cloud/com}
echo "TEST DONE! The test results are available at ${API_ENDPOINT}/#service/testrun/${TESTDROID_PROJECT_ID}/${TESTRUN_ID}"


#Get Sumary of test run

#TESTREPORT="$(curl -H "Accept: application/json" -X GET -u ${TESTDROID_APIKEY}: "${API_ENDPOINT}/api/v2/me/projects/${TESTDROID_PROJECT_ID}/runs/${TESTRUN_ID}/reports/summary?type=HTML")"

#echo "Test report: ${TESTREPORT}"

#curl -s -H "Accept: application/json" -u 0WD5ezcDOJpWDtXECDgzjCQ6nMDalKoB: -X POST "https://cloud.testdroid.com/api/v2/me/projects/99662668/#runs/102548081/abort"

# fi
