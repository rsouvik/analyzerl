#!/bin/bash
# stream client

ERLC=/usr/bin/erl
EBIN=./ebin

start() {

   #start client 
   CMD="$ERLC -sname client -pa $EBIN -noshell -detached -s generator start"
   echo "RUNNING CLIENT"
   $CMD 

return 0

}

stop() {

return 0
}

if [ "$1" == "start" ]; 
then 
   start
   echo "Starting Client......"
fi
