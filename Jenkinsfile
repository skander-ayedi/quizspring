pipeline {
  agent any
    environment {
	    	DOCKERHUB_CREDENTIALS=credentials('dockerhub') 
	     }
    tools {
        maven "3.6.3"
        }

    stages {
        stage('Clone') {
            steps {
                   git branch: 'main', credentialsId: 'github', url:'https://github.com/skander-ayedi/quizspring.git'
                  }
        }
         stage("Maven Build") {
            steps {
                script {
                    sh "mvn clean package -DskipTests=true"
                }
            }
        }
        stage("sonarqube") {
                steps { withSonarQubeEnv(installationName: 'sonar 8.3',credentialsId: 'sonarqube-token') {
                      sh """mvn sonar:sonar \
                             -Dsonar.projectKey=spring \
                             -Dsonar.host.url=http://192.168.50.128:9000 \
                             -Dsonar.login=0f03ff43cdd5e4a17f0a6954c3a6758c2bb2e894"""
                    }
               }
         }
        stage("Publish to Nexus") {
            steps {
                script {
                    nexusArtifactUploader artifacts: [
                    [
                        artifactId: 'SpringBootQuizApp',
                        classifier: '',
                        file: 'target/SpringBootQuizApp-0.0.1-SNAPSHOT.jar',
                        type: 'jar']
                        ], 
                        credentialsId: 'nexus',
                        groupId: 'com.devrezaur',
                        nexusUrl: '192.168.50.165:8081', 
                        nexusVersion: 'nexus3',
                        protocol: 'http',
                        repository: 'maven-snapshots/',
                        version: '0.0.1-SNAPSHOT'
                }
            }
        }
        stage('Docker Build') {
         steps {
            sh 'docker build -t skander:latest .'
            }
        }
      
      stage('Login') { 
         steps {
            	sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
		}
	  stage('Push') {
		 steps {
                sh 'docker push skander2/skander:latest'
            }
		}
		stage('Deploy to K8s') {
		 steps {
                kubernetesDeploy configs: 'deployment.yml', kubeconfigId: 'k8scluster'
            }
		}
	    
		
		
    }
}
