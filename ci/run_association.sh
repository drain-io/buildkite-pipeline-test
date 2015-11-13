#!/bin/bash
set -exo pipefail

. $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/prepare

. $SCRIPT_DIR/cleanup_kar.sh

cleanup_kar

rm -rf $KARAF_HOME/deploy/*
rm -rf $KARAF_HOME/data/*

docker run -d -e POSTGRES_USER=association -e POSTGRES_PASSWORD=association -p 5432:5432 postgres

sleep 10

psql --echo-all -h localhost -U association -d association -f \
	$PROJECT_DIR/example/association/association-po/target/classes/ddl_postgresql.sql

psql --echo-all -h localhost -U association -d association -f \
	$PROJECT_DIR/example/association/association-po/target/classes/setup.sql

cp $PROJECT_DIR/example/association/association-kar/target/*.kar $KARAF_HOME/deploy
$KARAF_HOME/bin/start

$SCRIPT_DIR/is_started.sh 90















