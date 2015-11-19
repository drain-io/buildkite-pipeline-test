#!/bin/bash

function load_credentials {
	CREDS_FILE=$PROJECT_DIR/.credentials
	if [ -f "$CREDS_FILE" ]; then
		. $CREDS_FILE
	fi
}

function maven_settings {
	cp $SCRIPT_DIR/maven-settings.tmpl $TARGET_DIR/maven-settings.xml
	$SCRIPT_DIR/substenv.sh $TARGET_DIR/maven-settings.xml
}

function github_settings {
	cp $SCRIPT_DIR/netrc.tmpl $HOME/.netrc
	$SCRIPT_DIR/substenv.sh $HOME/.netrc
}

function s3_settings {
	cp $SCRIPT_DIR/s3cfg.tmpl $HOME/.s3cfg
	$SCRIPT_DIR/substenv.sh $HOME/.s3cfg
}

load_credentials

