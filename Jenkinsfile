pipeline {
    agent any

    environment {
        DOTNET_PROJECT = 'frontend/easy-devops.csproj'
        SNYK_TOKEN_ID = 'snyk-api-token' // Configure in Jenkins: Manage Jenkins > Credentials
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Restore') {
            steps {
                pwsh "dotnet restore ${env.DOTNET_PROJECT}"
            }
        }

        stage('Build') {
            steps {
                pwsh "dotnet build ${env.DOTNET_PROJECT} --configuration Release --no-restore"
            }
        }

        stage('Test') {
            steps {
                pwsh "dotnet test ${env.DOTNET_PROJECT} --configuration Release --no-build"
            }
        }

        stage('Snyk Scan') {
            steps {
                script {
                    try {
                        snykSecurity(
                            snykInstallation: 'snyk',
                            snykTokenId: env.SNYK_TOKEN_ID,
                            additionalArguments: '--all-projects',
                            severity: 'medium',
                            failOnIssues: false
                        )
                    } catch (Exception e) {
                        echo "Snyk: ${e.message}"
                        currentBuild.result = 'UNSTABLE'
                    }
                }
            }
        }

        stage('Publish') {
            steps {
                pwsh """
                    dotnet publish ${env.DOTNET_PROJECT} `
                        -c Release `
                        -r win-x64 `
                        --self-contained true `
                        -o out/publish `
                        /p:PublishSingleFile=true `
                        /p:PublishTrimmed=true
                """
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'out/publish/**/*', allowEmptyArchive: true
        }
    }
}
