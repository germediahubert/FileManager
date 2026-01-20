# This script downloads and installs JDK and Maven
# Run as Administrator

Write-Host "Starting installation of JDK and Maven..." -ForegroundColor Green

# Create installation directory
$installDir = "C:\Java"
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir | Out-Null
    Write-Host "Created $installDir"
}

# Download JDK 21 (using Eclipse Temurin as it's reliable)
Write-Host "Downloading JDK 21..." -ForegroundColor Yellow
$jdkUrl = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.1%2B12/OpenJDK21U-jdk_x64_windows_hotspot_21.0.1_12.zip"
$jdkPath = "$installDir\jdk-21.zip"

try {
    Invoke-WebRequest -Uri $jdkUrl -OutFile $jdkPath -ErrorAction Stop
    Write-Host "JDK downloaded successfully" -ForegroundColor Green
    
    # Extract JDK
    Write-Host "Extracting JDK..." -ForegroundColor Yellow
    Expand-Archive -Path $jdkPath -DestinationPath $installDir
    Remove-Item $jdkPath
    Write-Host "JDK extracted" -ForegroundColor Green
} catch {
    Write-Host "Failed to download JDK. Please download manually from: https://adoptium.net/temurin/" -ForegroundColor Red
}

# Download Maven
Write-Host "Downloading Maven..." -ForegroundColor Yellow
$mavenUrl = "https://archive.apache.org/dist/maven/maven-3/3.9.5/binaries/apache-maven-3.9.5-bin.zip"
$mavenPath = "$installDir\maven.zip"

try {
    Invoke-WebRequest -Uri $mavenUrl -OutFile $mavenPath -ErrorAction Stop
    Write-Host "Maven downloaded successfully" -ForegroundColor Green
    
    # Extract Maven
    Write-Host "Extracting Maven..." -ForegroundColor Yellow
    Expand-Archive -Path $mavenPath -DestinationPath $installDir
    Remove-Item $mavenPath
    Write-Host "Maven extracted" -ForegroundColor Green
} catch {
    Write-Host "Failed to download Maven. Please download manually from: https://maven.apache.org/" -ForegroundColor Red
}

# Add to PATH
Write-Host "Adding to PATH..." -ForegroundColor Yellow
$jdkBin = "$installDir\jdk-21.0.1+12\bin"
$mavenBin = "$installDir\apache-maven-3.9.5\bin"

$currentPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
if ($currentPath -notlike "*$jdkBin*") {
    [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$jdkBin", "Machine")
    Write-Host "Added JDK to PATH" -ForegroundColor Green
}

if ($currentPath -notlike "*$mavenBin*") {
    [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$mavenBin", "Machine")
    Write-Host "Added Maven to PATH" -ForegroundColor Green
}

# Set JAVA_HOME
[Environment]::SetEnvironmentVariable("JAVA_HOME", $jdkBin, "Machine")
Write-Host "Set JAVA_HOME" -ForegroundColor Green

Write-Host "Installation complete! Please restart PowerShell and VS Code." -ForegroundColor Green
Write-Host "Then try running: mvn clean package" -ForegroundColor Cyan
