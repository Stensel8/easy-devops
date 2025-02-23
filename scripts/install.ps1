# This script installs .NET SDK 8, .NET Runtime 8, Git, clones the repository, and runs the easy-devops app.
# The terminal remains open on errors.

# Variables for .NET installers
$DotnetSdkUrl = "https://download.visualstudio.microsoft.com/download/pr/ba3a1364-27d8-472e-a33b-5ce0937728aa/6f9495e5a587406c85af6f93b1c89295/dotnet-sdk-8.0.404-win-x64.exe"
$DotnetSdkChecksum = "c48518ba763f6b72ce8c83a4289e4f2468c5b654b80ccebc410d3c76b10729ee803ce0964d698e1dc11fffd09ec07e16684db48c2877cf57e7608a773eb02738"
$DotnetRuntimeUrl = "https://download.visualstudio.microsoft.com/download/pr/3512c49f-ccac-4d0c-8b78-5889dd48d4b3/f6ba9c8452e7dcc7dc97bef268640f40/dotnet-runtime-8.0.11-win-x64.exe"
$DotnetInstallerPath = "$env:Temp\dotnet-installer.exe"

# Variables for Git installer
$GitInstallerUrl  = "https://github.com/git-for-windows/git/releases/download/v2.47.1.windows.1/Git-2.47.1-64-bit.exe"
$GitInstallerPath = "$env:Temp\Git-2.47.1-64-bit.exe"

# Repository details
$RepoUrl = "https://github.com/stensel8/easy-devops.git"
$RepoDirectory = "C:/easy-devops"

# Check if a command exists
function Test-Command {
    param([string]$Command)
    return $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

# Verify SHA512 checksum of a file
function Test-Checksum {
    param(
        [string]$FilePath, 
        [string]$ExpectedChecksum
    )
    $ActualChecksum = (Get-FileHash -Path $FilePath -Algorithm SHA512).Hash
    return $ActualChecksum -eq $ExpectedChecksum
}

# Pause the script to allow user input
function Wait-Script {
    Write-Host "`nPress ENTER to continue or close this window manually..."
    [void][System.Console]::ReadLine()
}

Write-Host "Detecting installed .NET versions..." -ForegroundColor Cyan
try {
    $InstalledSdks = & dotnet --list-sdks | Out-String
    $InstalledRuntimes = & dotnet --list-runtimes | Out-String
} catch {
    Write-Host "Could not detect .NET SDKs or Runtimes. Dotnet may not be installed." -ForegroundColor Yellow
    $InstalledSdks = ""
    $InstalledRuntimes = ""
}

Write-Host "Installed .NET SDKs:" -ForegroundColor Green
Write-Host $InstalledSdks
Write-Host "Installed .NET Runtimes:" -ForegroundColor Green
Write-Host $InstalledRuntimes

Write-Host "`nChecking for .NET SDK 8..." -ForegroundColor Cyan
if ($InstalledSdks -notmatch "8.0") {
    Write-Host ".NET SDK 8 is not installed. Attempting installation using winget..." -ForegroundColor Yellow
    try {
        Start-Process -FilePath "winget" -ArgumentList "install --id Microsoft.DotNet.SDK.8 --silent --accept-package-agreements --accept-source-agreements" -Wait -NoNewWindow
        Write-Host ".NET SDK 8 installed via winget." -ForegroundColor Green
    } catch {
        Write-Host "Winget installation failed. Falling back to manual installation." -ForegroundColor Red
        try {
            Write-Host "Downloading .NET SDK 8 installer..." -ForegroundColor Cyan
            Start-BitsTransfer -Source $DotnetSdkUrl -Destination $DotnetInstallerPath
            Write-Host "Verifying checksum..." -ForegroundColor Cyan
            if (-not (Test-Checksum -FilePath $DotnetInstallerPath -ExpectedChecksum $DotnetSdkChecksum)) {
                Write-Host "Checksum verification failed. Please verify the installer URL and checksum." -ForegroundColor Red
                Wait-Script
                return
            }
            Write-Host "Installing .NET SDK 8..." -ForegroundColor Cyan
            Start-Process -FilePath $DotnetInstallerPath -ArgumentList "/quiet" -Wait
            Write-Host ".NET SDK 8 installed." -ForegroundColor Green
        } catch {
            Write-Host "Manual installation failed. Please install .NET 8 SDK manually from:" -ForegroundColor Red
            Write-Host "https://dotnet.microsoft.com/en-us/download" -ForegroundColor Red
            Pause-Script
            return
        }
    }
} else {
    Write-Host ".NET SDK 8 is already installed." -ForegroundColor Green
}

Write-Host "`nChecking for .NET Runtime 8..." -ForegroundColor Cyan
if ($InstalledRuntimes -notmatch "8.0") {
    Write-Host ".NET Runtime 8 is not installed. Attempting installation using winget..." -ForegroundColor Yellow
    try {
        Start-Process -FilePath "winget" -ArgumentList "install --id Microsoft.DotNet.Runtime.8 --silent --accept-package-agreements --accept-source-agreements" -Wait -NoNewWindow
        Write-Host ".NET Runtime 8 installed via winget." -ForegroundColor Green
    } catch {
        Write-Host "Winget installation failed. Falling back to manual installation." -ForegroundColor Red
        try {
            Write-Host "Downloading .NET Runtime 8 installer..." -ForegroundColor Cyan
            Start-BitsTransfer -Source $DotnetRuntimeUrl -Destination $DotnetInstallerPath
            Write-Host "Installing .NET Runtime 8..." -ForegroundColor Cyan
            Start-Process -FilePath $DotnetInstallerPath -ArgumentList "/quiet" -Wait
            Write-Host ".NET Runtime 8 installed." -ForegroundColor Green
        } catch {
            Write-Host "Manual installation failed. Please install .NET 8 Runtime manually from:" -ForegroundColor Red
            Write-Host "https://dotnet.microsoft.com/en-us/download" -ForegroundColor Red
            Pause-Script
            return
        }
    }
} else {
    Write-Host ".NET Runtime 8 is already installed." -ForegroundColor Green
}

Write-Host "`nChecking for Git installation..." -ForegroundColor Cyan
if (-not (Test-Command "git")) {
    Write-Host "Git is not installed. Attempting installation using winget..." -ForegroundColor Yellow
    try {
        Start-Process -FilePath "winget" -ArgumentList "install --id Git.Git --silent --accept-package-agreements --accept-source-agreements" -Wait -NoNewWindow
        Write-Host "Git installed via winget." -ForegroundColor Green
    } catch {
        Write-Host "Winget installation failed. Attempting manual installation." -ForegroundColor Red
        try {
            Write-Host "Downloading Git installer..." -ForegroundColor Cyan
            Start-BitsTransfer -Source $GitInstallerUrl -Destination $GitInstallerPath
            Write-Host "Launching Git installer. Please follow the setup wizard..." -ForegroundColor Cyan
            Start-Process -FilePath $GitInstallerPath -Wait
            Write-Host "Complete the Git installation manually if needed." -ForegroundColor Yellow
        } catch {
            Write-Host "Manual installation failed. Please install Git manually from: https://git-scm.com" -ForegroundColor Red
            Pause-Script
            return
        }
    }
} else {
    Write-Host "Git is already installed." -ForegroundColor Green
}

Write-Host "`n--------------------------------------------------------------"
Write-Host "You may need to restart your shell or system for changes to take effect."
Write-Host "--------------------------------------------------------------`n"

Write-Host "Cloning the repository..." -ForegroundColor Cyan
if (-not (Test-Path -Path $RepoDirectory)) {
    try {
        git clone $RepoUrl $RepoDirectory
        Write-Host "Repository cloned successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to clone repository. Check your Git installation and network connection." -ForegroundColor Red
        Pause-Script
        return
    }
} else {
    Write-Host "Repository already exists at $RepoDirectory." -ForegroundColor Yellow
}

Write-Host "`nRunning the easy-devops app..." -ForegroundColor Cyan
$FrontendAppPath = Join-Path $RepoDirectory "frontend"
$env:PATH += ";C:\Program Files\dotnet"
Set-Location -Path $FrontendAppPath
if (Get-ChildItem -Filter *.csproj -Path $FrontendAppPath) {
    try {
        dotnet run
        Write-Host "The easy-devops app is running." -ForegroundColor Green
    } catch {
        Write-Host "Failed to run the app. Check the project structure and dependencies." -ForegroundColor Red
        Pause-Script
        return
    }
} else {
    Write-Host "No .csproj file found in $FrontendAppPath." -ForegroundColor Red
    Pause-Script
    return
}

Write-Host "`nScript completed." -ForegroundColor Green
Pause-Script
