pipeline {
    agent any

    environment {
        // Minimum required .NET version
        DOTNET_MIN_VERSION = '8.0.0'
        // Define application path
        APP_PATH = 'frontend/easy-devops/easy-devops.csproj'
    }

    stages {
        stage('Environment Check') {
            steps {
                echo '--- Stage: Environment Check ---'
                script {
                    try {
                        echo 'Checking current PATH environment variable...'
                        echo "Current PATH: ${System.getenv('PATH')}"
                    } catch (Exception e) {
                        echo "Failed to print PATH: ${e.message}"
                        error 'Environment check failed.'
                    }
                }
            }
        }

        stage('Check .NET Installation') {
            steps {
                echo '--- Stage: Check .NET Installation ---'
                script {
                    try {
                        echo 'Checking if .NET is installed...'
                        def installedVersion = powershell(script: 'dotnet --version', returnStdout: true).trim()
                        echo "Installed .NET version: ${installedVersion}"

                        // Compare the installed version with the minimum required version
                        if (compareVersions(installedVersion, env.DOTNET_MIN_VERSION) < 0) {
                            error "Installed .NET version (${installedVersion}) is below the required version (${env.DOTNET_MIN_VERSION})."
                        }
                    } catch (Exception e) {
                        echo "Error while checking .NET installation: ${e.message}"
                        echo '.NET is not installed or not accessible. Please install the required version.'
                        error 'Please install .NET and re-run the pipeline.'
                    }
                }
            }
        }

        stage('Restore Dependencies') {
            steps {
                echo '--- Stage: Restore Dependencies ---'
                script {
                    try {
                        echo 'Restoring project dependencies using dotnet restore...'
                        powershell "dotnet restore ${env.APP_PATH}"
                    } catch (Exception e) {
                        echo "Error while restoring dependencies: ${e.message}"
                        error 'Dependency restoration failed. Check your project files or network connection.'
                    }
                }
            }
        }

        stage('Build Application') {
            steps {
                echo '--- Stage: Build Application ---'
                script {
                    try {
                        echo 'Building the application in Release mode...'
                        powershell "dotnet build ${env.APP_PATH} --configuration Release"
                    } catch (Exception e) {
                        echo "Error during build: ${e.message}"
                        error 'Build failed. Please fix the issues in your code or build configuration.'
                    }
                }
            }
        }

        stage('Run Application') {
            steps {
                echo '--- Stage: Run Application ---'
                script {
                    try {
                        echo 'Executing the application...'
                        powershell 'dotnet run --project frontend/easy-devops'
                    } catch (Exception e) {
                        echo "Error while running the application: ${e.message}"
                        error 'Application run failed. Check your runtime configuration or code.'
                    }
                }
            }
        }

        stage('Test Application') {
            steps {
                echo '--- Stage: Test Application ---'
                script {
                    try {
                        echo 'Running simple tests...'
                        echo 'Performing output verification (mock example).'
                        powershell '''
                        $output = dotnet run --project frontend/easy-devops
                        if ($output -match "Expected output text") {
                            Write-Host "Test passed: Application produced expected output."
                        } else {
                            Write-Host "Test failed: Application did not produce expected output."
                            exit 1
                        }
                        '''
                    } catch (Exception e) {
                        echo "Error during testing: ${e.message}"
                        error 'Tests failed. Verify your application logic or test cases.'
                    }
                }
            }
        }

        stage('Deploy Application') {
            steps {
                echo '--- Stage: Deploy Application ---'
                script {
                    try {
                        echo 'Deploying application (placeholder for deployment logic)...'
                        echo 'This could involve copying files to a server or running additional scripts.'
                    } catch (Exception e) {
                        echo "Error during deployment: ${e.message}"
                        error 'Deployment failed. Check your deployment steps or server configuration.'
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed. Review the logs for any warnings or issues.'
        }
        success {
            echo 'Pipeline finished successfully! The application is ready.'
        }
        failure {
            echo 'Pipeline failed. Please review the logs above for detailed errors.'
        }
    }
}

// Function to compare two version strings (e.g., "8.0.0" and "7.2.1")
def compareVersions(String v1, String v2) {
    // Split versions into major, minor, and patch parts
    def v1Parts = v1.tokenize('.').collect { it.toInteger() }
    def v2Parts = v2.tokenize('.').collect { it.toInteger() }

    // Compare each part (major, minor, patch)
    for (int i = 0; i < Math.max(v1Parts.size(), v2Parts.size()); i++) {
        def p1 = i < v1Parts.size() ? v1Parts[i] : 0
        def p2 = i < v2Parts.size() ? v2Parts[i] : 0
        if (p1 != p2) return p1 <=> p2 // Return comparison result (-1, 0, or 1)
    }
    return 0 // Return 0 if versions are equal
}
