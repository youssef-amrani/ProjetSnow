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
        
        stage('Convert Robot Results to JUnit Format') {
            steps {
                bat 'python -m robot.rebot --xunit xunit_result.xml output.xml'
            }
        }

        stage('Debug: Check Files') {
            steps {
                bat 'dir'
                bat 'type xunit_result.xml'
            }
        }

        stage('Publish Test Results') {
            steps {
                junit 'xunit_result.xml'
            }
        }
    }
}
