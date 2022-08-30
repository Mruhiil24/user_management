#  Buildkite User Management

This project was completed as part of my summer internship at Campspot from May - August 2022.

The goal of this project is to create a serverless application (a python lambda function from AWS) which scrapes data for newly added Buildkite users every month. 

This serverless application will be developed and deployed using a CI/CD pipeline consisting of version-control tool (Git) and build tool(Buildkite).
The application will be running on docker container and the image will be stored on AWS ECR. Additionally Terraform will be used as Infrastructure as Code tool to create the resources in AWS.
Create S3 bucket to store final lambda output.

The application will run in local environment when credentials are updated and it is connected to AWS.
