# Define project directory
$ProjectRoot = "C:\Yongky_Assignment\auto_driving_project"
$ProjectFolder = "$ProjectRoot\autocar-driving-test"
$GitRepo = "https://github.com/Overcomer21/autocar-driving-test.git"
$ExtractFolder = "$ProjectRoot\extract"
$ZipFile = "$ProjectFolder\autocar-driving-test.zip"
$LogFile = "$ProjectRoot\setup_log.txt"

# Function to write output to both console and log file
Function Write-Log {
    Param ([string]$Message)
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "$TimeStamp - $Message"
    Write-Host $LogEntry

    # Ensure the log directory and file exist before writing
    if (-Not (Test-Path -Path $ProjectRoot)) {
        New-Item -ItemType Directory -Path $ProjectRoot -Force | Out-Null
    }
    if (-Not (Test-Path -Path $LogFile)) {
        New-Item -ItemType File -Path $LogFile -Force | Out-Null
    }

    # Ensure proper UTF-8 encoding for English characters only
    [System.IO.File]::AppendAllText($LogFile, $LogEntry + "`r`n", [System.Text.Encoding]::UTF8)
}

# Start Logging
Write-Log "Script Execution Started."

# Step 1: Create the Project Folder (if it doesn't exist)
Write-Log "Creating Project Directory..."
if (-Not (Test-Path -Path $ProjectRoot)) {
    New-Item -ItemType Directory -Path $ProjectRoot -Force | Out-Null
}
if (-Not (Test-Path -Path $ProjectFolder)) {
    New-Item -ItemType Directory -Path $ProjectFolder -Force | Out-Null
}

Write-Log "Project Directory Ready."

# Step 2: Clone Git Repository
Write-Log "Cloning Git Repository..."
Set-Location -Path $ProjectRoot
if (Test-Path "$ProjectFolder\.git") {
    Write-Log "Git Repository Already Exists, Pulling Latest Changes..."
    git pull | Tee-Object -FilePath $LogFile -Append
} else {
    git clone $GitRepo | Tee-Object -FilePath $LogFile -Append
}

# Step 3: Extract TypeScript Project Files
Write-Log "Checking for TypeScript Project ZIP File..."
if (Test-Path -Path $ZipFile) {
    Write-Log "Extracting TypeScript Project Files..."
    
    # Ensure the extract folder exists
    if (-Not (Test-Path -Path $ExtractFolder)) {
        New-Item -ItemType Directory -Path $ExtractFolder -Force | Out-Null
    }

    # Extract ZIP file
    Expand-Archive -Path $ZipFile -DestinationPath $ExtractFolder -Force
    Write-Log "Extraction Completed."

    # Overwrite existing project folder with extracted files
    Write-Log "Moving extracted files to $ProjectFolder..."
    if (Test-Path -Path $ProjectFolder) {
        Remove-Item -Path $ProjectFolder -Recurse -Force
    }
    Move-Item -Path "$ExtractFolder\*" -Destination $ProjectFolder -Force
    Remove-Item -Path $ExtractFolder -Recurse -Force  # Cleanup Extract Folder

    Write-Log "Files successfully moved to project folder."
} else {
    Write-Log "Zip File Not Found. Skipping Extraction Step."
}


# Step 4: Install Pre-Requisites (Node.js)
Write-Log " Installing Node.js..."
$NodeInstaller = "$env:TEMP\nodejs.msi"
Invoke-WebRequest -Uri "https://nodejs.org/dist/v23.9.0/node-v23.9.0-x64.msi" -OutFile $NodeInstaller
Start-Process msiexec.exe -ArgumentList "/i $NodeInstaller /quiet /norestart" -Wait
Remove-Item -Path $NodeInstaller -Force

# Verify Node.js Installation
Write-Log " Verifying Node.js Installation..."
node -v | Tee-Object -FilePath $LogFile -Append
npm -v | Tee-Object -FilePath $LogFile -Append

# Step 5: Open Visual Studio Code (Optional)
Write-Log " Opening Visual Studio Code..."
Start-Process "code" -ArgumentList $ProjectFolder

# Step 6: Navigate to the Project Folder
Write-Log " Navigating to Project Folder..."
Set-Location -Path $ProjectFolder

# Step 7: Initialize the Project
Write-Log " Initializing the Project..."
npm init -y | Tee-Object -FilePath $LogFile -Append

# Step 8: Install TypeScript
Write-Log " Installing TypeScript..."
npm install -g typescript | Tee-Object -FilePath $LogFile -Append

# Step 9: Rebuild the Project
Write-Log " Rebuilding the Project..."
tsc --build | Tee-Object -FilePath $LogFile -Append

# Step 10: Install Jest for Auto Testing
Write-Log " Installing Jest for Auto Testing..."
npm install --save-dev jest @types/jest ts-jest | Tee-Object -FilePath $LogFile -Append
npx ts-jest config:init | Tee-Object -FilePath $LogFile -Append

# Step 11: PART 1 - Tesla Car Auto - Driving (Single Car) Test
Write-Log " Running Tesla Car Auto - Driving (Single Car) Test..."
tsc | Tee-Object -FilePath $LogFile -Append
Write-Log "Executing Pre-Test for Single Car..."
node auto_driving.js | Tee-Object -FilePath $LogFile -Append

# Step 12: PART 2 - Tesla Car Auto - Driving (Single Car) with Collisions and No-Collisions Test
Write-Log "Running Tesla Car Auto - Driving (Multi-Car) Test..."
tsc | Tee-Object -FilePath $LogFile -Append
Write-Log " Executing Pre-Test for Multi-Car..."
node auto_driving_multi.js | Tee-Object -FilePath $LogFile -Append

# Step 13: Run Automated Tests using Jest
Write-Log "Executing Automated Tests with Jest..."
npx jest | Tee-Object -FilePath "$ProjectFolder\output_result_log.txt" -Append

Write-Log "All Steps Completed Successfully!"
