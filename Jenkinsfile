pipeline {
    
    agent  {label 'app-worker'}

    options{
        buildDiscarder(logRotator(daysToKeepStr: '5'))
        disableConcorrentBuilds()
        timeout(time: 2,unit: 'MINUTES')
        retry(3)
    }

    parameters {
        string(name: 'BRANCH',defaultValue: 'master')
        choice(name: 'ENVIRONMENT',choices: ['Dev','Feature','QA','Prod'])
    }

    environment {
        ENVIRONMENT='global'
        ECR_REPO_LINK = '262324735239.dkr.ecr.us-east-1.amazonaws.com'
        ECR_REPO_NAME = 'assgn-c3-repo'
    }

    stages {
        stage('GIT CHECKOUT'){
            checkout scm
        }

        stage('BUILD AND PUBLISH'){
            sh "ls -l"
            sh "echo Starting to build docker image."
            sh "docker build -t ${ECR_REPO_NAME}:v${BUILD_NUMBER} ."
            sh "docker tag ${ECR_REPO_NAME}:v${BUILD_NUMBER} ${ECR_REPO_LINK}/${ECR_REPO_NAME}:v${BUILD_NUMBER}"
            sh "docker push ${ECR_REPO_LINK}/${ECR_REPO_NAME}:v${BUILD_NUMBER}"
            sh "echo Docker push complete"
        }

    }

}