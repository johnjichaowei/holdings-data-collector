# holdings-data-collector
A Lambda function to collect financial data for the holdings received from SQS queue, and store the collected data to S3.

## Setup project

### Config access to AWS

Set AWS Credentials [using environment variables](https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/setup-config.html#aws-ruby-sdk-credentials-environment)

### Install Docker
Install [Docker](https://docs.docker.com/install/) & [Docker Compose](https://docs.docker.com/compose/install/)

Then,

```
docker-compose build
```

## Run tests

```
docker-compose run --rm test
```

## Deploy to AWS

```
docker-compose run --rm dev rake deploy
```

## Deployment details

The deploy rake task deploys the lambda function to AWS with below steps,

- Create the lambda package to `dist/lambda.zip` with the source code and dependencies
- Deploy the S3 bucket cloudformation stack to AWS to store the lambda package
- Upload the lambda package to the S3 bucket
- Deploy the S3 bucket cloudformation stack to AWS to store the collected holdings data
- Deploy the lambda function cloudformation stack to AWS
- Update the lambda function code, so the lambda function can be updated even there is no cloudformation change
