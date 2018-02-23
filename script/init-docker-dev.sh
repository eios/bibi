#!/usr/bin/env bash

NET_IP=192.168.0.0/24
MY_NET=$(docker network ls |awk '$2=="mynet" {print $2}')
REDIS_IP=192.168.0.10
MONGO_IP=192.168.0.12

if [ ! "$MY_NET" ];then
    echo "create mynet"
    docker network create --driver=bridge --subnet=${NET_IP} --gateway=192.168.0.1 mynet
else
    echo "$MY_NET is exist"
fi

if [ ! `docker ps -a | awk '$2=="redis" {print $2}'` ];then
    echo "run docker redis"
    docker run --name redis-local --ip=${REDIS_IP} --net=mynet --restart=always -d redis redis-server --appendonly yes
else
    echo "reids container is exist"
fi

if [ ! `docker ps -a | awk '$2=="mongo" {print $2}'` ];then
    echo "run docker mongo"
    docker run --name mongo-local --ip=${MONGO_IP} --net=mynet --restart=always -d mongo

else
    echo "mongo container is exist"
fi