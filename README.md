# holdings-data-collector
A Lambda function to collect financial data for the holdings received from SQS queue, and store the collected data to S3.

## Setup project

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
