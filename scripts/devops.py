import os
import subprocess
import sys

# Project details
DOCKER_IMAGE_NAME = "easy-devops:latest"
DOCKER_CONTAINER_NAME = "easy-devops-container"
PROJECT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
CS_PROJECT_PATH = os.path.join(PROJECT_DIR, "frontend", "easy-devops.csproj")

# Function to run shell commands
def run_command(command):
    print(f"Running: {' '.join(command)}")
    result = subprocess.run(command, capture_output=True, text=True)
    print(result.stdout)
    if result.stderr:
        print(f"Error: {result.stderr}")
        sys.exit(1)

# Build the .NET application
def build_dotnet_app():
    print("Building the .NET application...")
    os.chdir(PROJECT_DIR)  # Ensure we're in the project root directory
    run_command(["dotnet", "publish", CS_PROJECT_PATH, "-c", "Release", "-o", "out"])

# Build the Docker image
def build_docker_image():
    print("Building the Docker image...")
    dockerfile_path = os.path.join(PROJECT_DIR, "kubernetes", "Dockerfile")
    run_command(["docker", "build", "-t", DOCKER_IMAGE_NAME, "-f", dockerfile_path, "."])

# Run the Docker container
def run_docker_container():
    print("Running the Docker container...")
    run_command(["docker", "run", "-d", "--name", DOCKER_CONTAINER_NAME, "-p", "8080:80", DOCKER_IMAGE_NAME])

# Main function to handle commands
def main(action):
    if action == "build":
        build_dotnet_app()
    elif action == "dockerize":
        build_dotnet_app()
        build_docker_image()
    elif action == "run":
        run_docker_container()
    elif action == "all":
        build_dotnet_app()
        build_docker_image()
        run_docker_container()
    else:
        print("Usage: python devops.py {build|dockerize|run|all}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python devops.py {build|dockerize|run|all}")
    else:
        main(sys.argv[1])
