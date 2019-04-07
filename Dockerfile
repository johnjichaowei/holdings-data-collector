From ruby:2.5-alpine

ENV APP_HOME /app
WORKDIR $APP_HOME

CMD sh

RUN gem update bundler

COPY Gemfile Gemfile.lock $APP_HOME/

RUN apk update && \
    apk --no-cache --virtual .build-deps add gcc make g++ && \
    bundle install --jobs 6 --retry 2 && \
    apk del .build-deps

COPY . $APP_HOME/
