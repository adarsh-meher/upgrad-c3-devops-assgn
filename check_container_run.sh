#!/bin/sh

echo "Check if we have any container running."

CONT_STATIC_NAME="node-app"
ECR_REPO_LINK="262324735239.dkr.ecr.us-east-1.amazonaws.com"
ECR_REPO_NAME="assgn-c3-repo"



x=$(docker ps -aqf "name=$CONT_STATIC_NAME")
echo "$x"


if [ -z "$x" ]
then
        null_check="Null"
else
        null_check="Not Null"
fi

echo "$null_check"
if [ "$null_check" = "Null" ]
then 
    echo "No container running."
    echo "Starting new docker container"
    docker run -itd -p 8081:8081 --name $CONT_STATIC_NAME $(docker images  -aq ${ECR_REPO_LINK}/${ECR_REPO_NAME} | head -n 1)
    echo "Container started."
fi


if [ "$null_check" = "Not Null" ]
then
    echo "Some container running."
    echo "Stopping the container."
    docker stop $x
    docker rm $x
    echo "Starting new docker container"
    docker run -itd -p 8081:8081 --name $CONT_STATIC_NAME  $(docker images  -aq ${ECR_REPO_LINK}/${ECR_REPO_NAME} | head -n 1)
    echo "Container started."
fi