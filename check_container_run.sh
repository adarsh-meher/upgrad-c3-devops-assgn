#! /bin/bash

echo "Check if we have any container running."

CONT_STATIC_NAME="node_app"
ECR_REPO_LINK = "262324735239.dkr.ecr.us-east-1.amazonaws.com"
ECR_REPO_NAME = "assgn-c3-repo"



x=$(docker ps -aqf "name=${CONT_STATIC_NAME}")
null_check = if [ -z "$x" ];then echo "Null";else echo "Not Null";fi

if [ $null_check -eq "Null" ]
then 
    echo "No container running."
    echo "Starting new docker container"
    docker run -itd -p 8081:8081 --name $CONT_STATIC_NAME  ${ECR_REPO_LINK}/${ECR_REPO_NAME}:v${BUILD_NUMBER}
    echo "Container started."
fi

if [ $null_check -eq "Not Null" ]
then
    echo "Some container running."
    echo "Stopping the container."
    docker stop $x
    docker rm $x
    echo "Starting new docker container"
    docker run -itd -p 8081:8081 --name $CONT_STATIC_NAME  ${ECR_REPO_LINK}/${ECR_REPO_NAME}:v${BUILD_NUMBER}
    echo "Container started."