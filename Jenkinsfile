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
                bat 'robot -d results C:\\Users\\geams\\OneDrive\\Bureau\\ProjetAlten\\test.robot'
            }
        }
        
        stage('Convert Robot Results to JUnit Format') {
            steps {
                bat 'python -m robot.rebot --xunit results\\xunit_result.xml results\\output.xml'
            }
        }

        stage('Debug: Check Files') {
            steps {
                bat 'dir /s'
                bat 'type results\\xunit_result.xml'
            }
        }

        stage('Publish Test Results') {
            steps {
                junit 'results/xunit_result.xml'
            }
        }
    }
}
