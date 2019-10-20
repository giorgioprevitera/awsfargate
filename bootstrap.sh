#!/usr/bin/env bash

set -euo pipefail

S3_BUCKET_NAME="fargatetest-terraform"

create_pipeline() {
    fly -t fargate sp \
        -c pipelines/"${1}.yml" \
        -p "${1}" \
        -l pipelines/vars_fargatetest.yaml \
        -v aws_access_key_id="${AWS_ACCESS_KEY_ID}" \
        -v aws_secret_access_key="${AWS_SECRET_ACCESS_KEY}" \
        -n
}

bucket_dont_exists() {
    aws s3 ls s3://${S3_BUCKET_NAME} 2>&1 | grep -q 'NoSuchBucket'
}

create_bucket() {
    aws s3api create-bucket \
        --bucket "${S3_BUCKET_NAME}" \
        --region eu-west-1 \
        --create-bucket-configuration LocationConstraint=eu-west-1
}

# Create S3 bucket for the Terraform state files
if bucket_dont_exists; then
    create_bucket
else
    echo "INFO: ${S3_BUCKET_NAME} already exists"
fi

# Login to Concourse and create pipelines
fly -t fargate status || fly -t fargate login

create_pipeline "build-and-push"
create_pipeline "run-terraform"
