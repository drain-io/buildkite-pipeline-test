#!/bin/bash
set -ex #o pipefail

. $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/prepare

rm -rf $KARAF_HOME/deploy/*
rm -rf $KARAF_HOME/data/*

POSTGRES_CONTAINER_NAME=judo-itest-postgres

container=$(docker ps|grep "$POSTGRES_CONTAINER_NAME"|wc -l)

if [ "$container" -ne "0" ]; then
	docker stop $POSTGRES_CONTAINER_NAME
	docker rm $POSTGRES_CONTAINER_NAME
fi 

docker run -d --name $POSTGRES_CONTAINER_NAME -e POSTGRES_USER=association -e POSTGRES_PASSWORD=association -p 5432:5432 postgres

$SCRIPT_DIR/is_started.sh  "psql --echo-all -h localhost -U association -d association -c \"select 1\">/dev/null 2>&1;echo \$?" postgresql 20 0

psql --echo-all -h localhost -U association -d association -f \
	$PROJECT_DIR/example/association/association-po/target/classes/ddl_postgresql.sql

psql --echo-all -h localhost -U association -d association -f \
	$PROJECT_DIR/example/association/association-po/target/classes/setup.sql

cp $PROJECT_DIR/example/association/association-kar/target/*.kar $KARAF_HOME/deploy
$KARAF_HOME/bin/start

$SCRIPT_DIR/is_started.sh "curl -H \"Authorization: Judo YWRtaW46eHh4\" --silent --output /dev/null --write-out \"%{http_code}\" localhost:8181/services/rest/judo/example/association/domain/classl8" 10 200

export TEST_RESULTS_DIR=$TARGET_DIR/testresults

mvn \
	-Dmaven.test.redirectTestOutputToFile=true \
	-DoutputDirectory=$TEST_RESULTS_DIR \
 	-Dmaven.test.reportsDirectory=$TEST_RESULTS_DIR \
 	test surefire-report:report \
 	-f ./example/association/association-rest-test/pom.xml

 TEST_RESULT=$?

 docker stop $POSTGRES_CONTAINER_NAME

 exit $TEST_RESULT















