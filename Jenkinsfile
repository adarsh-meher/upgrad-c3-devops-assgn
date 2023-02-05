pipeline {
    
    agent  {label 'app-worker'}

    options{
        buildDiscarder(logRotator(daysToKeepStr: '5'))
        disableConcurrentBuilds()
        timeout(time: 2,unit: 'MINUTES')
        retry(1)
    }

    parameters {
        string(name: 'BRANCH',defaultValue: 'master')
        choice(name: 'ENVIRONMENT',choices: ['Dev','Feature','QA','Prod'])
    }

    environment {
        ENVIRONMENT = "global"
        ECR_REPO_LINK = "262324735239.dkr.ecr.us-east-1.amazonaws.com"
        ECR_REPO_NAME = "assgn-c3-repo"
        CONTAINER_STATIC_NAME = "node-app"
    }

    stages {
        stage('GIT CHECKOUT'){
            steps{
                checkout scm
            }
            
        }

        stage('BUILD AND PUBLISH'){
            steps {
            sh "ls -l"
            sh "echo Starting to build docker image."
            sh "docker build -t ${ECR_REPO_NAME}:v${BUILD_NUMBER} ."
            sh "docker tag ${ECR_REPO_NAME}:v${BUILD_NUMBER} ${ECR_REPO_LINK}/${ECR_REPO_NAME}:v${BUILD_NUMBER}"
            sh "docker push ${ECR_REPO_LINK}/${ECR_REPO_NAME}:v${BUILD_NUMBER}"
            sh "echo Docker push complete"
            }
            
        }

        stage('DEPLOY APP'){
            steps {
                sh "ls -l"
                sh '''
                cd /home/ubuntu/workspace/app-pipeline-v1
                chmod +x check_container_run.sh '''
                sh "echo $PWD"
                sh "ls -l"
                sh "Running script to check container status and take appropriate action."
                sh '''
                x=$(docker ps -aqf "name=${CONTAINER_STATIC_NAME}")
                null_check = if [ -z "$x" ];then echo "Null";else echo "Not Null";fi

                if [ $null_check -eq "Null" ]
                then 
                    echo "No container running."
                    echo "Starting new docker container"
                    docker run -itd -p 8081:8081 --name $CONTAINER_STATIC_NAME  ${ECR_REPO_LINK}/${ECR_REPO_NAME}:v${BUILD_NUMBER}
                    echo "Container started."
                fi

                if [ $null_check -eq "Not Null" ]
                then
                    echo "Some container running."
                    echo "Stopping the container."
                    docker stop $x
                    docker rm $x
                    echo "Starting new docker container"
                    docker run -itd -p 8081:8081 --name $CONTAINER_STATIC_NAME  ${ECR_REPO_LINK}/${ECR_REPO_NAME}:v${BUILD_NUMBER}
                    echo "Container started." '''

                sh "Completed."
            }
        }

    }

}