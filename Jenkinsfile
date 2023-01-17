 pipeline {
       agent any
    tools {
        maven 'mvn'
    }
        parameters { 
        string(name: 'REPO_NAME', description: 'PROVIDER THE NAME OF DOCKERHUB IMAGE', defaultValue: 'kojitechswebapp',  trim: true)
        string(name: 'REPO_URL', description: 'PROVIDER THE NAME OF DOCKERHUB/ECR URL', defaultValue: '735972722491.dkr.ecr.us-east-1.amazonaws.com',  trim: true)
        string(name: 'AWS_REGION', description: 'AWS REGION', defaultValue: 'us-east-1')
        choice(name: 'ACTION', choices: ['deploy', 'deploy', 'do-not-deploy'], description: 'Select action, BECAREFUL IF YOU SELECT DESTROY TO PROD')
    }
    environment {
            tag = sh(returnStdout: true, script: "git rev-parse --short=10 HEAD").trim()
        }
       stages {
           stage("Checkout Code") {
               steps {
                checkout scm
            }
           }
            stage('mvn Compile') {
                steps {
                    sh 'mvn spring-boot:run'
                }
            }
            stage('Unit Tests Execution') {
                steps {
                    sh 'mvn surefire:test'
                }
            }
            stage("Static Code analysis With SonarQube") {                                               
                steps {
              withSonarQubeEnv(installationName: 'sonar') {
                sh  'mvn clean org.sonarsource.scanner.maven:sonar-maven-plugin:3.9.0.2155:sonar'
              }
                }
            }
            stage ("Waiting for Quality Gate Result") {
                steps {
                    timeout(time: 3, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
                }
            }   
            stage ("Docker Build Image") {
                steps {
                    script {         
                    try {
                        sh""" 
                            docker images 
                            """ 
                    }catch (Exception e) {
                        echo 'An exception occurred while pushing image to docker hub'
                        echo e.getMessage()
                }
                }
                }
            }
          } 
      post {
        success {
            slackSend botUser: true, channel: 'jenkins_notification', color: 'good',
            message: " with ${currentBuild.fullDisplayName} completed successfully.\nMore info ${env.BUILD_URL}\nLogin to ${params.ENVIRONMENT} and confirm.", 
            teamDomain: 'slack', tokenCredentialId: 'slack'
        }
        failure {
            slackSend botUser: true, channel: 'jenkins_notification', color: 'danger',
            message: "${currentBuild.fullDisplayName} got failed.", 
            teamDomain: 'slack', tokenCredentialId: 'slack'
        }
        aborted {
            slackSend botUser: true, channel: 'jenkins_notification', color: 'hex',
            message: "Pipeline aborted due to a quality gate failure ${currentBuild.fullDisplayName} got aborted.\nMore Info ${env.BUILD_URL}", 
            teamDomain: 'slack', tokenCredentialId: 'slack'
        }
        cleanup {
            cleanWs()
        }
        } 
}       