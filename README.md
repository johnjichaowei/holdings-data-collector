# holdings-data-collector
A Lambda function to collect financial data for the holdings received from SQS queue, and store the data to S3.

## Setup project

### Config access to AWS

Set AWS Credentials [using environment variables](https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/setup-config.html#aws-ruby-sdk-credentials-environment)

### With Docker
Install [Docker](https://docs.docker.com/install/) & [Docker Compose](https://docs.docker.com/compose/install/)

```
docker-compose build
```

### On local machine
Install [Ruby version 2.5.5](https://www.ruby-lang.org/en/documentation/installation/)

```
gem install bundler

bundle install
```

## Run tests

### With Docker

```
docker-compose run --rm test
```

### On local machine

```
bundle exec rake
```
