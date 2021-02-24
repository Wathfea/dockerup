#!/bin/sh
set -e

if [[ "${APP_ENV}" = "local" ]]; then
  npm install && npm run watch
else
  npm install && npm run prod
fi
