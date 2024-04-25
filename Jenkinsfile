pipeline{
    agent any // run this pipeline any where
    tools{
        maven "maven"
    }
    environment{
           APP_NAME = "spring-docker-cicd"
           RELEASE_NO= "1.0.0"
           DOCKER_USER= "thalarikalyan"
           IMAGE_NAME= "${DOCKER_USER}"+"/"+"${APP_NAME}"
           IMAGE_TAG= "${RELEASE_NO}-${BUILD_NUMBER}"
    }
    stages{

        stage("SCM checkout"){
            steps{
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/thalarikalyan/spring-jenkins-docker-integration.git']])
            }
        }
        stage("Build Process"){
            steps{
                script{
                    bat 'mvn clean install -DskipTests'

                }
            }
        }
        stage("Build Docker Image and Container") {
            steps {
                script {
                    bat 'docker build -t springboot-crud-mysql-k8s-integration:1.0 .'
                    bat 'docker tag transaction-docker-k8s:1.0 thalarikalyan/springboot-crud-mysql-k8s-integration:1.0'
                    bat 'docker images'
                }
            }
        }
         stage("Deploy Docker Image to Docker HUB") {
            steps {
                withCredentials([string(credentialsId: 'docker credentails', variable: 'docker-creds')]) {
                    bat 'docker images' // Print images before tagging
                    bat 'docker login -u thalarikalyan -p %docker-creds%'
                    bat 'docker push thalarikalyan/transaction-docker-k8s:1.0'
}
            }
        }
        stage("Deploy Docker Image to Kubernetes") {
            steps {

                script{
                    // Use the kubeconfig step to configure kubectl with Kubernetes credentials
                kubeconfig(credentialsId: 'KubernetesConfig', serverUrl: 'https://127.0.0.1:51489') {
                bat 'kubectl apply -f mysql-configMap.yaml'
                bat 'kubectl apply -f mysql-secrets.yaml'
                 bat 'kubectl apply -f db-deployment.yaml'
                  bat 'kubectl apply -f app-deployment.yaml'
                }
            }





            }
        }



    }
    post{
        always{
            emailext attachLog: true, body: '''<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Build Status</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        background-color: #f4f4f4;
    }
    .container {
        max-width: 600px;
        margin: 50px auto;
        background-color: #fff;
        border-radius: 5px;
        padding: 20px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    h1 {
        color: #333;
        text-align: center;
    }
    .status {
        text-align: center;
        margin-top: 30px;
    }
    .success {
        color: green;
    }
    .failure {
        color: red;
    }
</style>
</head>
<body>
<div class="container">
    <h1>Build Status</h1>
    <div class="status">
        <p>Build Status : <span class="success">Build Status : ${BUILD_STATUS}</span></p>
        <p>Pipeline status : <span class="success">Pipeline status : ${BUILD_NUMBER}</span></p>
    </div>
    <p>Thanks,<br>Bhagyamma</p>
</div>
</body>
</html>
''', mimeType: 'text/html', replyTo: 'thalarikalyaninfo@gmai.com', subject: 'PipeLineStatus : ${BUILD_NUMBER}', to: 'thalarikalyaninfo@gmail.com'
        }
        }
    }

//SCM checkout
//Build
//deploy
//email