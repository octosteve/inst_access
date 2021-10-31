FROM instructure/ruby-passenger:2.7

ENV RAILS_ENV "production"

USER root

RUN apt-get update -qq \
  && apt-get install -qqy \
       git \
  && rm -rf /var/lib/apt/lists/*

USER docker

COPY --chown=docker:docker Gemfile inst_access.gemspec ./

RUN bundle install --jobs 8

COPY --chown=docker:docker . .

CMD [ "/usr/src/app/bin/entrypoint.sh" ]
