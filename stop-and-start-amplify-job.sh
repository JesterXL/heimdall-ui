#!/bin/bash

amplify_id=""
region="us-east-1"
git_branch=""
amplify_dev_id=""
amplify_staging_id=""
amplify_prod_id=""

while getopts e:b: flag
do
    case "${flag}" in
        e) environment=${OPTARG};;
        b) git_branch=${OPTARG};;
    esac
done

printf "About to deploy branch: $git_branch\n"

# if [[ $environment == "dev" ]]
# then
#     printf "Setting Amplify App to Dev\n"
# elif [[ $environment == "staging" ]]
# then
#     printf "Setting Amplify App to Staging\n"
# elif [[ $environment == "prod" ]]
# then
#     printf "Setting Amplify App to Production\n"
# else
#     echo "Error: Unknown environment $environment, should be dev, staging, or prod.\n"
#     exit 1
# fi

printf "Create the code archive\n"
# We only do this for main
if [[ $git_branch == "main" ]]
then
    archive="public.zip"
    printf "Git branch is main, so creating $archive...\n"
    if [ -f "$archive" ] ; then
        printf "Delete previously created archive\n"
        rm "$archive"
    fi
    cd public
    zip -q -r $archive .
    cd -
    cp "public/$archive" $archive
    if [ -f "$archive" ]
    then
        printf "Successfully created $archive\n"
    else
        printf "Failed to create $archive\n"
        exit 3
    fi
elif [[ $git_branch == "main-minus-one" ]]
then
    archive="public_rollback.zip"
    printf "Git branch is not main, so creating $archive instead...\n"
    if [ -f "$archive" ]
    then
        printf "Rollback file $archive exists, ready to upload.\n"
    else
        printf "Failed to find previously built $archive rollback file, aborting.\n"
        exit 4
    fi
else
    echo "Error: Unknown git_branch: $git_branch, should be main or main-minus-one."
    exit 2
fi

printf "Get latest Amplify job\n"
aws amplify list-jobs \
--app-id $amplify_id \
--branch-name $git_branch \
--max-items 1 > amplify-last-job.json \
--region $region

AMPLIFY_LAST_JOB_STATUS=$(cat amplify-last-job.json \
| jq -r '.jobSummaries[].status')
AMPLIFY_LAST_JOB_ID=$(cat amplify-last-job.json \
| jq -r '.jobSummaries[].jobId')

if [ "$AMPLIFY_LAST_JOB_STATUS" = "PENDING" ]; then
    printf "Found a previous job in pending, stopping it\n"
    aws amplify stop-job \
    --app-id $amplify_id \
    --branch-name $git_branch \
    --job-id $AMPLIFY_LAST_JOB_ID \
    --region $region
fi

printf "Create Amplify deployment\n"
aws amplify create-deployment \
--app-id $amplify_id \
--branch-name $git_branch > amplify-deploy.json \
--region $region

AMPLIFY_ZIP_UPLOAD_URL=$(cat amplify-deploy.json | jq -r '.zipUploadUrl')
AMPLIFY_JOB_ID=$(cat amplify-deploy.json | jq -r '.jobId')

printf "Upload archive\n"
curl -H "Content-Type: application/zip" \
$AMPLIFY_ZIP_UPLOAD_URL \
--upload-file $archive

printf "Start Amplify deployment\n"
aws amplify start-deployment \
    --app-id $amplify_id \
    --branch-name $git_branch \
    --job-id $AMPLIFY_JOB_ID \
    --region $region

while :
do
    sleep 10

    # Poll the deployment job status every 10 seconds until it's not pending
    # anymore
    STATUS=$(aws amplify get-job \
        --app-id $amplify_id \
        --branch-name $git_branch \
        --job-id $AMPLIFY_JOB_ID \
        --region $region \
        | jq -r '.job.summary.status')
    printf "Job status: $STATUS\n"

    if [ $STATUS != 'PENDING' ]; then
        break
    fi
done

printf "Amplify deployment status $STATUS\n"