pipeline { 
    agent any

    environment {
        ROBOT_RESULTS_DIR = "${WORKSPACE}/robot_results"
    }

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
                bat "robot -d ${ROBOT_RESULTS_DIR} ${WORKSPACE}/test_incident.robot"
            }
        }
        
        stage('Convert Robot Results to JUnit Format') {
            steps {
                bat "python -m robot.rebot --xunit ${ROBOT_RESULTS_DIR}/xunit_result.xml ${ROBOT_RESULTS_DIR}/output.xml"
            }
        }

        stage('Debug: Check Files') {
            steps {
                bat "dir ${ROBOT_RESULTS_DIR}"
                bat "type ${ROBOT_RESULTS_DIR}/xunit_result.xml"
            }
        }

        stage('Publish Test Results') {
            steps {
                junit '**/robot_results/xunit_result.xml'
            }
        }
    }
}
