pipeline {
    agent any

    stages {
        stage('Get git perository') {
            steps {
                git credentialsId: '5d3091f2-9a6e-4f99-ac9c-280a5c0094f4', url: 'git@github.com:LexionN/vector-role.git'
            }
        }
        stage('Run molecule test') {
            steps {
                sh 'molecule test'
            }
        }   
    }    
   
}

