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
                // Conversion de output.xml vers un fichier xunit compatible JUnit
                bat 'rebot --outputdir C:\\Users\\geams\\.jenkins\\workspace\\TestRobot_Pipeline --xunit xunit_result.xml C:\\Users\\geams\\.jenkins\\workspace\\TestRobot_Pipeline\\output.xml'
            }
        }

        stage('Publish Test Results') {
            steps {
                // Publie le fichier converti
                junit 'C:\\Users\\geams\\.jenkins\\workspace\\TestRobot_Pipeline\\xunit_result.xml'
            }
        }
    }
    
    // Supprime ou commente ce bloc, car il tente de publier output.xml directement
    /*
    post {
        always {
            junit '**/output.xml'
        }
    }
    */
}
