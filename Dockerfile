FROM ruby:3.4.1 as base

WORKDIR /src/rc/app

ENTRYPOINT ["ruby", "main.rb"]

FROM base AS release

COPY ./ /src/rc/app/

ENTRYPOINT ["ruby", "main.rb"]