# Easy-DevOps App

A simple and user-friendly application designed for technical management and monitoring. Developed as a school project to demonstrate the basic principles of DevOps and Jenkins basics.

> **Note**: This application is not intended for production use. It serves as a demonstration and learning tool for DevOps practices and Jenkins pipeline basics.

---

## Features

- **Welcome Print**: A simple welcome message similar to the classic "Hello, World!".
- **Live Clock**: Displays the current time, updated every 5 seconds.
- **Response Times**: Real-time ping response times to well-known domains:
  - Google
  - GitHub
  - Microsoft
- **DevOps and Jenkins Basics**: Built to help beginners:
  - Learn DevOps practices, such as CI/CD.
  - Understand Jenkins pipelines, stages, and basic API integrations.
- **Educational Focus**: Ideal for introducing DevOps concepts to beginners.

---

## Getting Started

### Prerequisites

- **.NET SDK**: [Download and install .NET SDK](https://dotnet.microsoft.com/download) (version 8.0 or later is recommended).
- **Git**: Ensure Git is installed on your system. [Download Git](https://git-scm.com) if needed.
- **Jenkins (optional)**: Set up Jenkins to explore CI/CD basics with this app. [Learn more about Jenkins](https://www.jenkins.io/).

### Manual Installation
- For automatic deployment, you can run the pre-defined powershell-file:
   ```bash
   .\scripts\install.ps1
---

### Manual Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/stensel8/easy-devops.git
2. Navigate to the project directory:
   ```bash
   cd easy-devops/frontend
3. Build the application:
   ```bash
   dotnet build
4. Run the application:
   ```bash
   dotnet run
---

# Docker/Kubernetes Containerization (New/Beta)

This application can be built and packaged as a container for use with Docker and Kubernetes. 

**To get started:**

1. **Navigate to the scripts folder:**

   ```bash
   cd scripts
   ```
2. **Choose the desired action:**
- Build the application:

   ```bash
   python devops.py build
   ```
- Create the image:

   ```bash
   python devops.py dockerize
   ```
- Run the container:

   ```bash
   python devops.py run
   ```
- Run all steps (build, dockerize, and run):

   ```bash
   python devops.py all
   ```
3. **Deploy to Kubernetes (optional):**
Refer to the kubernetes/ folder for deployment configurations (e.g., deployment.yaml) to deploy the application on a Kubernetes cluster.
