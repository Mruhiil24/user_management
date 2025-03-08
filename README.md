# Buildkite User Audit and Access Management System

This project was completed as part of my summer internship at Campspot from May - August 2022.

This project automates the process of scraping Buildkite user data for auditing and access management. The system is built with a **serverless AWS Lambda function** that scrapes Buildkite user data and stores it in **AWS S3**. The project leverages **Docker**, **AWS Lambda**, **Terraform**, and **CI/CD** using **Buildkite** to automate the deployment and management of the scraping function.

## Objective

The goal of this project is to create an automated system that:

1. Scrapes Buildkite user data monthly.
2. Stores the gathered data in AWS S3 for auditing purposes.
3. Automates the deployment and management of the solution using a CI/CD pipeline, Docker, AWS, and Terraform.

By the end of the project, the system will:
- Gather up-to-date data about user access and permissions from Buildkite.
- Store the data securely in AWS S3.
- Automate the deployment process using Buildkite CI/CD.

## Technologies Used

### 1. AWS Lambda
   - Serverless compute service that runs the Python-based scraping function.

### 2. AWS ECR (Elastic Container Registry)
   - Used to store the Docker image that contains the Lambda function and its dependencies.

### 3. Selenium
   - Used for web scraping by simulating browser interaction to extract data from Buildkite.

### 4. Terraform
   - Infrastructure as Code (IaC) tool used to provision and manage AWS resources such as Lambda, S3, and IAM roles.

### 5. Docker
   - Containerizes the Lambda function and its dependencies (e.g., Selenium and Chrome) to ensure it runs consistently across different environments.

### 6. Buildkite
   - CI/CD tool used for automating the build, test, and deployment of the Dockerized Lambda function.

### 7. Honeycomb
   - Provides observability and monitoring for the Lambda function, tracking performance and logs.

### 8. AWS S3
   - Durable and scalable storage for storing the scraped Buildkite user data.

### 9. AWS IAM
   - Manages permissions for AWS resources, ensuring Lambda has the right permissions to access S3, CloudWatch, and other resources.

## Goals and Features

1. **Serverless Web Scraping with AWS Lambda**:
   - Use AWS Lambda to run the scraping function in a serverless manner, reducing the need for managing infrastructure.

2. **Automated Deployment**:
   - Automate the build and deployment of the Lambda function using a CI/CD pipeline with Buildkite.

3. **Data Storage**:
   - Store the scraped data in AWS S3 for long-term storage and auditing.

4. **Observability**:
   - Integrate Honeycomb for real-time monitoring and observability of Lambda function performance.

5. **Infrastructure as Code**:
   - Use Terraform to provision and manage AWS resources in a reproducible manner.


