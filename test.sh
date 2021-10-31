#!/bin/bash
set -e
docker-compose run --rm inst_access bundle insall
docker-compose run --rm inst_access bundle exec rspec
