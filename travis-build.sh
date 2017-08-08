#!/bin/bash
set -e

# This script is meant to run on Travis-CI only
if [ -z "$TRAVIS_BRANCH" ]; then 
  echo "ABORTING: this script runs on Travis-CI only"
  exit 1
fi
# Check essential envs
if [ -z "$GH_TOKEN" ]; then
  echo "ABORTING: env GH_TOKEN is missing"
  exit 1
fi
export $GITHUB_TOKEN="$GH_TOKEN"
# verbose logging
set -x

# create a build number
export BUILD_NR="$(date '+%Y%m%d-%H%M%S')"
echo "BUILD_NR=$BUILD_NR"

# run build
export DEFCONFIG=rpi_defconfig
docker-compose build
docker-compose run builder

# deploy to GitHub releases
export GIT_TAG=v$BUILD_NR
export GIT_RELTEXT="Auto-released by [Travis-CI build #$TRAVIS_BUILD_NUMBER](https://travis-ci.org/$TRAVIS_REPO_SLUG/builds/$TRAVIS_BUILD_ID)"
curl -sSL https://github.com/tcnksm/ghr/releases/download/v0.5.4/ghr_v0.5.4_linux_amd64.zip > ghr.zip
unzip ghr.zip
./ghr --version
./ghr --debug -u xjx00 -b "$GIT_RELTEXT" $GIT_TAG builds/$BUILD_NR/
