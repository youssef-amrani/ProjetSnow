pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ElMouddenRiad/ProjetAlten.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                bat 'pip install -r requirements.txt'
            }
        }

        stage('Run Robot Tests') {
            steps {
                bat 'robot C:\\Users\\geams\\OneDrive\\Bureau\\ProjetAlten\\test.robot'
            }
        }

        stage('Archive Results') {
            steps {
                archiveArtifacts artifacts: '**/output.xml', fingerprint: true
            }
        }
    }

    post {
        always {
            junit '**/output.xml'
        }
    }
}
