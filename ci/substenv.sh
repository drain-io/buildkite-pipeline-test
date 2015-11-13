#!/bin/bash
set -eo pipefail

if [ "$1" == "" ]; then echo "need to specify an input file"; exit 1; fi

cp $1 /tmp
contents=\"\"\"`cat /tmp/$(basename $1)`\"\"\"; python -c "import os;print $contents.format(**os.environ)" > $1