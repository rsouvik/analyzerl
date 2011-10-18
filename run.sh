#!/bin/bash
# analyzerl

ERLC=/usr/bin/erl
EBIN=./ebin

start() {

#first start the erlang vms/nodes on the cluster hosts 

if [ -e "cluster.txt" ];
then 
   while read line 
   do
     node=`echo $line | cut -d@ -f1`
     CMD="$ERLC -sname $line -pa $EBIN -noshell -detached"
     echo "NODE $node STARTING UP............."
     $CMD
   done <"cluster.txt"

   #start network
   CMD="$ERLC -sname networkMonitor -pa $EBIN -noshell -detached -s networkManager startNow"
   #CMD="$ERLC -sname networkMonitor -pa $EBIN -noshell -detached -s networkManager startOnNode"
   echo "Starting Network Manager"
   $CMD

   #start eventManager
   CMD="$ERLC -sname eventMonitor -pa $EBIN -noshell -detached -s eventManager startNow"
   #CMD="$ERLC -sname eventMonitor -pa $EBIN -noshell -detached -s eventManager startOnNode"
   echo "Starting Event Manager"
   $CMD

else
   echo "cluster.txt does not exist."
   exit 1
fi
return 0

}

stop() {

# stop event manager
# -- stops the logger
   CMD="$ERLC -noshell -s eventManager stop"
   echo "Stopping Event Manager"
   `$CMD` 
# stop network manager
# -- stops the compute elements
   CMD="$ERLC -noshell -s networkManager stop"
   echo "Stopping Network Manager"
   `$CMD`

# shut down nodes/vms
# use erl_call?
   while read line 
   do
     node=`echo $line | cut -d@ -f1`
     CMD="$ERLC -noshell -sname controlNode -eval rpc:call($line, init, stop, []) -s init stop"
     echo "NODE $line SHUTTING DOWN ............."
     `$CMD`
   done <"cluster.txt"
return 0
}

if [ "$1" == "start" ]; 
then 
   start
   echo "Starting AnalyzERL Cluster"
elif [ "$1" == "stop" ];
then
   stop
   echo "Stopping the system"
fi
