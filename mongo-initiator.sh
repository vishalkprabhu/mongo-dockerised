#!/bin/bash

sleep 10

mongodb1=$(getent hosts mongo1 | awk '{ print $1 }')
mongodb2=$(getent hosts mongo2 | awk '{ print $1 }')

until curl http://${mongodb1}:27018/serverStatus\?text\=1 2>&1 | grep uptime | head -1; do
  sleep 1
done

mongosh --host ${mongodb1}:27018 --eval "rs.initiate({_id: '${MONGO_REPLICA_SET_NAME}', members: [{ _id: 0, host : '${mongodb1}:27018', priority: 2 }, { _id: 1, host : '${mongodb2}:27018', priority: 0 }]})"
