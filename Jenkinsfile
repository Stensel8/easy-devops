pipeline {
    agent any

    environment {
        // Minimum required .NET version
        DOTNET_MIN_VERSION = '8.0.0'
    }

    stages {
        stage('Check .NET Installation') {
            steps {
                script {
                    echo 'Checking if .NET is installed...'
                    try {
                        // Get the installed .NET version
                        def installedVersion = sh(script: 'dotnet --version', returnStdout: true).trim()
                        echo "Installed .NET version: ${installedVersion}"

                        // Compare the installed version with the minimum required version
                        if (compareVersions(installedVersion, env.DOTNET_MIN_VERSION) < 0) {
                            error "Installed .NET version (${installedVersion}) is below the required version (${env.DOTNET_MIN_VERSION}). Please update .NET."
                        }
                    } catch (Exception e) {
                        // If .NET is not installed, show instructions
                        echo '.NET is not installed on this system.'
                        echo 'To install the latest .NET SDK, run the following commands:'
                        echo '1. Update winget:'
                        echo '   winget upgrade --all'
                        echo '2. Install the .NET SDK:'
                        echo '   winget install -e --id Microsoft.DotNet.SDK.8'
                        error 'Please install .NET and re-run the pipeline.'
                    }
                }
            }
        }
        stage('Build') {
            steps {
                echo 'Starting the build process...'
                // Build the .NET project in Release mode
                bat 'dotnet build "frontend/easy-devops/easy-devops.csproj" --configuration Release'
            }
        }
        stage('Test') {
            steps {
                echo 'Running security tests with Snyk...'
                // Run Snyk security scan
                snykSecurity(
                    snykInstallation: 'snyk', 
                    snykTokenId: 'snyk-api-token', 
                    targetFile: 'frontend/easy-devops/obj/project.assets.json'
                )
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying the application...'
                // Add deployment logic here
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed.'
        }
        success {
            echo 'Pipeline finished successfully.'
        }
        failure {
            echo 'Pipeline failed. Please check the logs for details.'
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
