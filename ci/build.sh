#!/bin/bash
set -exo pipefail

. $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/prepare

. $SCRIPT_DIR/setup_credentials.sh

mkdir -p $TARGET_DIR

github_settings

mkdir -p $LOCAL_MAVEN_REPO

rm -rf $LOCAL_MAVEN_REPO/* || true
rm -rf $LOCAL_MAVEN_REPO/.indexes/* || true
rm -rf $HOME/.judo-npm/* || true
rm -rf $HOME/.judo-frontend/* || true

mvn -DaltDeploymentRepository=local-repository::default::file://$LOCAL_MAVEN_REPO --batch-mode clean deploy

for kar in `find $LOCAL_MAVEN_REPO -type f | sed -n "/.*.kar$/p"`; do
	zip -d $kar "*maven-metadata-local.xml"
done


