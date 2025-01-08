FROM ruby:3.4.1 AS dev

WORKDIR /usr/rc/app

FROM dev AS release

COPY ./ /usr/rc/app/

ENTRYPOINT ["ruby", "main.rb"]