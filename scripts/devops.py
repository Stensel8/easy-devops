import os
import subprocess
import sys

# Project details
DOCKER_IMAGE_NAME = "stensel8/easy-devops:latest"
DOCKER_CONTAINER_NAME = "easy-devops-container"
PROJECT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
CS_PROJECT_PATH = os.path.join(PROJECT_DIR, "frontend", "easy-devops.csproj")

def run_command(command):
    print(f"Running: {' '.join(command)}")
    result = subprocess.run(command, capture_output=True, text=True)
    print(result.stdout)
    if result.stderr:
        print(f"Error: {result.stderr}")
        sys.exit(1)

def build_dotnet_app():
    """
    Build a self-contained Linux binary (for Ubuntu).
    """
    print("Building .NET self-contained for Linux (glibc-based)...")
    os.chdir(PROJECT_DIR)
    run_command([
        "dotnet", "publish", CS_PROJECT_PATH,
        "-c", "Release",
        "-r", "linux-x64",
        "--self-contained", "true",
        "-o", "out/docker",
        "/p:PublishTrimmed=true",
        "/p:PublishSingleFile=true",
        "/p:IncludeAllContentForSelfExtract=true",
        "/p:PublishReadyToRun=true"
    ])

def build_dotnet_exe():
    """
    Build a self-contained Windows executable (.exe).
    """
    print("Building .NET self-contained for Windows (win-x64)...")
    os.chdir(PROJECT_DIR)
    run_command([
        "dotnet", "publish", CS_PROJECT_PATH,
        "-c", "Release",
        "-r", "win-x64",
        "--self-contained", "true",
        "-o", "out/exe",
        "/p:PublishTrimmed=true",
        "/p:PublishSingleFile=true",
        "/p:IncludeAllContentForSelfExtract=true",
        "/p:PublishReadyToRun=true"
    ])

def build_docker_image():
    print("Building the Docker image...")
    dockerfile_path = os.path.join(PROJECT_DIR, "kubernetes", "Dockerfile")
    run_command(["docker", "build", "-t", DOCKER_IMAGE_NAME, "-f", dockerfile_path, PROJECT_DIR])

def run_docker_container():
    print("Running the Docker container...")
    run_command(["docker", "run", "-it", "--rm", "--name", DOCKER_CONTAINER_NAME, DOCKER_IMAGE_NAME])

def main(action):
    if action == "build":
        build_dotnet_app()
    elif action == "build-exe":
        build_dotnet_exe()
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
        print("Usage: python devops.py {build|build-exe|dockerize|run|all}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python devops.py {build|build-exe|dockerize|run|all}")
    else:
        main(sys.argv[1])
