#!/bin/bash
set -exo pipefail

. $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/prepare

. $SCRIPT_DIR/.credentials
. $SCRIPT_DIR/create_settings.sh

mkdir -p $TARGET_DIR

create_settings

mkdir -p $LOCAL_MAVEN_REPO

rm -rf $LOCAL_MAVEN_REPO/* || true
rm -rf $LOCAL_MAVEN_REPO/.indexes/* || true
rm -rf $HOME/.judo-npm/* || true
rm -rf $HOME/.judo-frontend/* || true

mvn -DaltDeploymentRepository=local-repository::default::file://$LOCAL_MAVEN_REPO --batch-mode clean deploy --settings $TARGET_DIR/maven-settings.xml




