pipeline { 
    agent any

    environment {
        ROBOT_RESULTS_DIR = "${WORKSPACE}"
        PYTHON_ENV = "c:/Users/geams/OneDrive/Bureau/ProjetAlten/.venv/Scripts"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ElMouddenRiad/ProjetAlten.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                bat "${PYTHON_ENV}/python -m pip install --upgrade pip"
                bat "${PYTHON_ENV}/pip install -r ${WORKSPACE}/requirements.txt"
                bat "${PYTHON_ENV}/pip install robotframework-requests robotframework-jsonlibrary"
            }
        }
        stage('Debug: Check Installed Packages') {
            steps {
                bat "${PYTHON_ENV}/pip list"
            }
        }

        stage('Run Robot Tests') {
            steps {
                bat "${PYTHON_ENV}/robot -d ${ROBOT_RESULTS_DIR} ${WORKSPACE}/tests/test_incident.robot"
            }
        }
        
        stage('Convert Robot Results to JUnit Format') {
            steps {
                bat "${PYTHON_ENV}/python -m robot.rebot --xunit ${ROBOT_RESULTS_DIR}/xunit_result.xml ${ROBOT_RESULTS_DIR}/output.xml"
            }
        }

        stage('Debug: Check Files') {
            steps {
                bat "dir ${ROBOT_RESULTS_DIR}"
                bat 'type C:\\Users\\geams\\.jenkins\\workspace\\TestRobot_Pipeline\\xunit_result.xml'
            }
        }

        stage('Publish Test Results') {
            steps {
                junit '**/xunit_result.xml'
            }
        }
    }
}
