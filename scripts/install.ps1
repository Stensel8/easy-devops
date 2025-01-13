# Make this script PS1-friendly by not closing the terminal on errors.
# It will simply display messages and wait for user input.

# Define variables for .NET SDK and Runtime downloads (fallback installers)
$DotnetSdkUrl = "https://download.visualstudio.microsoft.com/download/pr/ba3a1364-27d8-472e-a33b-5ce0937728aa/6f9495e5a587406c85af6f93b1c89295/dotnet-sdk-8.0.404-win-x64.exe"
$DotnetSdkChecksum = "c48518ba763f6b72ce8c83a4289e4f2468c5b654b80ccebc410d3c76b10729ee803ce0964d698e1dc11fffd09ec07e16684db48c2877cf57e7608a773eb02738"
$DotnetRuntimeUrl = "https://download.visualstudio.microsoft.com/download/pr/3512c49f-ccac-4d0c-8b78-5889dd48d4b3/f6ba9c8452e7dcc7dc97bef268640f40/dotnet-runtime-8.0.11-win-x64.exe"
$DotnetInstallerPath = "$env:Temp\dotnet-installer.exe"

# Git manual install fallback
$GitInstallerUrl  = "https://github.com/git-for-windows/git/releases/download/v2.47.1.windows.1/Git-2.47.1-64-bit.exe"
$GitInstallerPath = "$env:Temp\Git-2.47.1-64-bit.exe"

# Repository details
$RepoUrl = "https://github.com/stensel8/easy-devops.git"
$RepoDirectory = "C:/easy-devops"

# Function to check if a command exists
function Test-Command {
    param([string]$Command)
    $CommandPath = Get-Command $Command -ErrorAction SilentlyContinue
    return ($null -ne $CommandPath)
}

# Function to verify SHA512 checksum
function Test-Checksum {
    param(
        [string]$FilePath, 
        [string]$ExpectedChecksum
    )

    $FileContent = Get-FileHash -Path $FilePath -Algorithm SHA512 | Select-Object -ExpandProperty Hash
    return ($FileContent -eq $ExpectedChecksum)
}

# Helper function to pause on error or completion
function Wait-Script {
    Write-Host "`nPress ENTER to continue or close this window manually..."
    [void][System.Console]::ReadLine()
}

# Print detected .NET SDKs and Runtimes
Write-Host "Detecting installed .NET versions..." -ForegroundColor Cyan
try {
    $InstalledSdks = & dotnet --list-sdks | Out-String
    $InstalledRuntimes = & dotnet --list-runtimes | Out-String
} catch {
    Write-Host "Could not detect installed .NET SDKs or Runtimes. Possibly dotnet is not installed at all." -ForegroundColor Yellow
    $InstalledSdks = ""
    $InstalledRuntimes = ""
}

Write-Host "Installed .NET SDKs:" -ForegroundColor Green
Write-Host $InstalledSdks
Write-Host "Installed .NET Runtimes:" -ForegroundColor Green
Write-Host $InstalledRuntimes

#--------------------------------------------------------------------------------------------
# Install .NET SDK 8
#--------------------------------------------------------------------------------------------
Write-Host "`nChecking for .NET SDK 8 installation..." -ForegroundColor Cyan
if ($InstalledSdks -notmatch "8.0") {
    Write-Host ".NET SDK 8 is not installed. Attempting installation using winget..." -ForegroundColor Yellow
    try {
        Start-Process -FilePath "winget" -ArgumentList "install --id Microsoft.DotNet.SDK.8 --silent --accept-package-agreements --accept-source-agreements" -Wait -NoNewWindow
        Write-Host ".NET SDK 8 installed successfully via winget." -ForegroundColor Green
    } catch {
        Write-Host "Failed to install .NET SDK using winget. Falling back to manual installation (BitsTransfer)..." -ForegroundColor Red
        try {
            Write-Host "Downloading .NET SDK 8 installer using BitsTransfer..." -ForegroundColor Cyan
            Start-BitsTransfer -Source $DotnetSdkUrl -Destination $DotnetInstallerPath

            Write-Host "Verifying checksum..." -ForegroundColor Cyan
            if (-not (Test-Checksum -FilePath $DotnetInstallerPath -ExpectedChecksum $DotnetSdkChecksum)) {
                Write-Host "Checksum verification failed for .NET SDK installer. Please verify the URL and checksum." -ForegroundColor Red
                Wait-Script
                return
            }

            Write-Host "Installing .NET SDK..." -ForegroundColor Cyan
            Start-Process -FilePath $DotnetInstallerPath -ArgumentList "/quiet" -Wait
            Write-Host ".NET SDK 8 installed successfully." -ForegroundColor Green
        } catch {
            Write-Host "Manual download/install for .NET SDK also failed. Please install .NET 8 SDK manually from:" -ForegroundColor Red
            Write-Host "https://dotnet.microsoft.com/en-us/download" -ForegroundColor Red
            Pause-Script
            return
        }
    }
} else {
    Write-Host ".NET SDK 8 is already installed." -ForegroundColor Green
}

#--------------------------------------------------------------------------------------------
# Install .NET Runtime 8
#--------------------------------------------------------------------------------------------
Write-Host "`nChecking for .NET Runtime 8 installation..." -ForegroundColor Cyan
if ($InstalledRuntimes -notmatch "8.0") {
    Write-Host ".NET Runtime 8 is not installed. Attempting installation using winget..." -ForegroundColor Yellow
    try {
        Start-Process -FilePath "winget" -ArgumentList "install --id Microsoft.DotNet.Runtime.8 --silent --accept-package-agreements --accept-source-agreements" -Wait -NoNewWindow
        Write-Host ".NET Runtime 8 installed successfully via winget." -ForegroundColor Green
    } catch {
        Write-Host "Failed to install .NET Runtime using winget. Falling back to manual installation (BitsTransfer)..." -ForegroundColor Red
        try {
            Write-Host "Downloading .NET Runtime 8 installer using BitsTransfer..." -ForegroundColor Cyan
            Start-BitsTransfer -Source $DotnetRuntimeUrl -Destination $DotnetInstallerPath

            Write-Host "Installing .NET Runtime 8..." -ForegroundColor Cyan
            Start-Process -FilePath $DotnetInstallerPath -ArgumentList "/quiet" -Wait
            Write-Host ".NET Runtime 8 installed successfully." -ForegroundColor Green
        } catch {
            Write-Host "Manual download/install for .NET Runtime also failed. Please install .NET 8 Runtime manually from:" -ForegroundColor Red
            Write-Host "https://dotnet.microsoft.com/en-us/download" -ForegroundColor Red
            Pause-Script
            return
        }
    }
} else {
    Write-Host ".NET Runtime 8 is already installed." -ForegroundColor Green
}

#--------------------------------------------------------------------------------------------
# Install Git
#--------------------------------------------------------------------------------------------
Write-Host "`nChecking for Git installation..." -ForegroundColor Cyan
if (-not (Test-Command "git")) {
    Write-Host "Git is not installed. Attempting installation using winget..." -ForegroundColor Yellow
    try {
        Start-Process -FilePath "winget" -ArgumentList "install --id Git.Git --silent --accept-package-agreements --accept-source-agreements" -Wait -NoNewWindow
        Write-Host "Git installed successfully via winget." -ForegroundColor Green
    } catch {
        Write-Host "Failed to install Git via winget. Attempting manual download..." -ForegroundColor Red
        try {
            Write-Host "Downloading Git installer using BitsTransfer..." -ForegroundColor Cyan
            Start-BitsTransfer -Source $GitInstallerUrl -Destination $GitInstallerPath

            Write-Host "Launching the Git installer. Please follow the setup wizard..." -ForegroundColor Cyan
            Start-Process -FilePath $GitInstallerPath -Wait

            Write-Host "Git setup was launched. Make sure to complete it manually." -ForegroundColor Yellow
        } catch {
            Write-Host "Manual download/install for Git also failed. Please install Git manually from: https://git-scm.com" -ForegroundColor Red
            Pause-Script
            return
        }
    }
} else {
    Write-Host "Git is already installed." -ForegroundColor Green
}

Write-Host "`n-----------------------------------------------------------------------------------"
Write-Host "If you recently installed or updated .NET or Git, you may need to restart your shell"
Write-Host "or your operating system for the environment variables to refresh."
Write-Host "-----------------------------------------------------------------------------------`n"

#--------------------------------------------------------------------------------------------
# Clone the repository
#--------------------------------------------------------------------------------------------
Write-Host "Attempting to clone the repository..." -ForegroundColor Cyan
if (-not (Test-Path -Path $RepoDirectory)) {
    try {
        git clone $RepoUrl $RepoDirectory
        Write-Host "Repository cloned successfully!" -ForegroundColor Green
    } catch {
        Write-Host "Failed to clone the repository. Please check your Git installation or network connection." -ForegroundColor Red
        Write-Host "You can try restarting your shell or PC and then run the script again." -ForegroundColor Yellow
        Pause-Script
        return
    }
} else {
    Write-Host "The repository already exists at the specified location ($RepoDirectory)." -ForegroundColor Yellow
}

#--------------------------------------------------------------------------------------------
# Run the easy-devops app
#--------------------------------------------------------------------------------------------
Write-Host "`nRunning the easy-devops app..." -ForegroundColor Cyan
$FrontendAppPath = Join-Path $RepoDirectory "frontend"

# Ensure .NET is available in the current session
$env:PATH += ";C:\Program Files\dotnet"

Set-Location -Path $FrontendAppPath
if (Test-Path "$FrontendAppPath\*.csproj") {
    try {
        dotnet run
        Write-Host "The easy-devops app is now running!" -ForegroundColor Green
    } catch {
        Write-Host "Failed to run the easy-devops app. Please check your setup." -ForegroundColor Red
        Write-Host "Possible issues include a missing csproj file or broken dependencies." -ForegroundColor Red
        Pause-Script
        return
    }
} else {
    Write-Host "No .csproj file found in $FrontendAppPath. Please check your project structure." -ForegroundColor Red
    Pause-Script
    return
}

Write-Host "`nScript completed." -ForegroundColor Green
Pause-Script