#!/bin/bash
function cleanup_kar {

	for kar in `find $LOCAL_MAVEN_REPO -type f | sed -n "/.*.kar$/p"`; do
	  zip -d $kar "*maven-metadata-local.xml"
	done
	
}


 