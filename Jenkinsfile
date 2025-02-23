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
                bat 'rebot --xunit C:\\Users\\geams\\.jenkins\\workspace\\TestRobot_Pipeline\\xunit_result.xml C:\\Users\\geams\\.jenkins\\workspace\\TestRobot_Pipeline\\output.xml'
            }
        }

        stage('Verify JUnit File') {
            steps {
                bat 'dir C:\\Users\\geams\\.jenkins\\workspace\\TestRobot_Pipeline'
            }
        }

        stage('Publish Test Results') {
            steps {
                junit '**/xunit_result.xml'
            }
        }
    }
}
