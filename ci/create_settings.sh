#!/bin/bash
function create_settings {

	cp $SCRIPT_DIR/maven-settings.tmpl $TARGET_DIR/maven-settings.xml
	$SCRIPT_DIR/substenv.sh $TARGET_DIR/maven-settings.xml

	cp $SCRIPT_DIR/netrc.tmpl $HOME/.netrc
	$SCRIPT_DIR/substenv.sh $HOME/.netrc

	cp $SCRIPT_DIR/s3cfg.tmpl $HOME/.s3cfg
	$SCRIPT_DIR/substenv.sh $HOME/.s3cfg
	
}