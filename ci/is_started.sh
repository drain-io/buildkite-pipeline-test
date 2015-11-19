#!/bin/bash
set -x

CHECK_COMMAND=$1
SERVICE_NAME=$2
TIMEOUT=$3
OK_RESULT=${4:-200}

RESULT="-1"

function is_started {
	RESULT=`bash -c "$1"`	
}

counter=0
while [ $counter -lt $TIMEOUT ] && [ $RESULT -ne "$OK_RESULT" ];
do
	#is_started "curl --silent --output /dev/null --write-out \"%{http_code}\" localhost:8181/services/rest/judo/example/association/domain/classl8"
	#psql --echo-all -h localhost -U association -d association -c "select 1">/dev/null 2>&1;echo $?

	is_started "$CHECK_COMMAND"
	sleep 1
	counter=$(( $counter + 1 ))

done
if [ $RESULT -ne "$OK_RESULT" ]; then
    echo "$SERVICE_NAME start TIMEOUT"
    exit 1
fi
echo "$SERVICE_NAME started OK in $counter secs"