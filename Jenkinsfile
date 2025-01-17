pipeline {
    agent any

    environment {
        DOTNET_PROJECT = 'frontend/easydevops/easydevops.csproj' // Path to your .NET project
        SNYK_TOKEN_ID = 'snyk-api-token' // Snyk API Token ID in Jenkins credentials
    }

    stages {
        stage('Checkout') {
            steps {
                echo '--- Stage: Checkout ---'
                // Pull the latest code from source control
                checkout scm
            }
        }

        stage('Restore Dependencies') {
            steps {
                echo '--- Stage: Restore Dependencies ---'
                // Restore .NET project dependencies
                bat "dotnet restore ${env.DOTNET_PROJECT}"
            }
        }

        stage('Build') {
            steps {
                echo '--- Stage: Build Application ---'
                // Build the .NET project in Release mode
                bat "dotnet build ${env.DOTNET_PROJECT} --configuration Release"
            }
        }

        stage('Run Tests') {
            steps {
                echo '--- Stage: Run Unit Tests ---'
                // Run tests for the .NET project
                bat "dotnet test ${env.DOTNET_PROJECT}"
            }
        }

        stage('Security Test - Snyk') {
            steps {
                echo '--- Stage: Run Snyk Security Scan ---'
                // Run Snyk security scan on the project
                snykSecurity(
                    snykInstallation: 'snyk',
                    snykTokenId: env.SNYK_TOKEN_ID,
                    targetFile: 'frontend/obj/project.assets.json'
                )
            }
        }

        stage('Deploy') {
            steps {
                echo '--- Stage: Deploy Application ---'
                // Placeholder for deployment steps
                echo 'Deployment logic will be added here.'
            }
        }
    }

    post {
        always {
            echo '--- Pipeline Finished ---'
            archiveArtifacts artifacts: '**/bin/**/*.dll, **/bin/**/*.exe', allowEmptyArchive: true
        }
        success {
            echo '--- Pipeline Completed Successfully! ---'
        }
        failure {
            echo '--- Pipeline Failed. Check the logs for more details. ---'
        }
    }
}
