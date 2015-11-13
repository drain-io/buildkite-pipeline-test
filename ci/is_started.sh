#!/bin/bash
set -x

STATUSCODE="0"

function is_started {
	STATUSCODE=$(curl --silent --output /dev/null --write-out "%{http_code}" localhost:8181/services/rest/judo/example/association/domain/classl8)	
}

counter=0
while [ $counter -lt $1 ] && [ $STATUSCODE -ne "200" ];
do
	is_started
	sleep 1
	counter=$(( $counter + 1 ))

done
if [ $STATUSCODE -ne "200" ]; then
    echo "karaf start TIMEOUT"
    exit 1
fi
echo "karaf start OK"