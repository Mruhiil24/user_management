#!/usr/bin/env bash
#run from parent directory ./Buildkite/upload-docker-image.sh
cd 2022/05/Buildkite

### Log in to AWS ECR
$(aws ecr get-login --no-include-email --region us-east-1)

### Specify AWS ECR
ECR_REPO=".dkr.ecr.us-east-1.amazonaws.com/docker-lambda"

### Build and Tag Docker Image
docker build -t $ECR_REPO .

### push Docker Image to ECR
docker push $ECR_REPO