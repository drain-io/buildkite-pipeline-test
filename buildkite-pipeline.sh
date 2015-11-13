#!/bin/bash

if [ -f ".buildkite/pipeline.yml" ];
then
  echo ".buildkite/pipeline.yml found, will replace current pipeline with steps from it"
  buildkite-agent pipeline upload --replace
else
  echo "No .buildkite/pipeline.yml file, using existing steps"
fi