pipeline {
    agent { 
        dockerfile true
    }

    environment {
        // Store password in Jenkins credentials
        SF_PASSWORD = credentials('2e839fd6-fa61-412b-b285-3e4c36e995b6')
    }

    tools {
        snowflakecli 'latest'
    }

    stages {
        stage('Run schemachange') {
            steps {
                sh "apt-get update && apt-get install -y python3.11-venv"
                sh "python3 -m pip install --upgrade pip"
                sh "python3 -m pip install schemachange --upgrade"
            }
        }
        stage('Test environment') {
            steps {
                sh "cd /var/jenkins_home"
                sh "ls -la"
            }
        }
        stage('Build') {
            steps {
                script {
sh """
cat <<EOF >> config.toml 
default_connection_name = "myconnection" 
  
[connections] 
[connections.myconnection]
account = "${SF_ACCOUNT}"
user = "${SF_USERNAME}"
authenticator = "username_password_mfa"
password = "${SF_PASSWORD}"
database = "${SF_DATABASE}"
schema = "${SF_SCHEMA}"
warehouse = "${SF_WAREHOUSE}"
role = "${SF_ROLE}"
EOF
"""
                    // Optional WithCredentials wrapper to define a private key passphrase if private key is encrypted.
                    withCredentials([usernamePassword(credentialsId: '2e839fd6-fa61-412b-b285-3e4c36e995b6', passwordVariable: 'SF_PASSWORD', usernameVariable: 'SF_USERNAME')]) {
                        // Use a wrap directive, set $class as SnowflakeCLIBuildWrapper and add the parameter for the path to the configuration file in your repository.
                        // This wrapper copies the information of the input file and stores it to a temporal config.toml file.
                        wrap([$class: 'SnowflakeCLIBuildWrapper', configFilePath: 'config.toml']) {
                            sh 'snow connection list'
                        }
                    }
                }
            }
        }
    }
}
