# Define credentials
$username = "Administrator"
$password = "Cool2Pass" | ConvertTo-SecureString -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($username, $password)

# List of remote computers
$computers = @("Server1", "Server2", "Server3")

# File details
$sourceURL = "https://example.com/file.exe"  # Replace with the actual URL
$destinationPath = "C:\Temp\file.exe"

# Store sessions
$sessions = @()

# Create PSSessions for each computer with credentials
foreach ($computer in $computers) {
    try {
        $session = New-PSSession -ComputerName $computer -Credential $cred -ErrorAction Stop
        $sessions += $session
        Write-Host "Connected to $computer"
    } catch {
        Write-Host "Failed to connect to $computer - $_"
    }
}

# Run commands on all sessions
if ($sessions.Count -gt 0) {
    Invoke-Command -Session $sessions -ScriptBlock {
        param ($sourceURL, $destinationPath)

        # Ensure Temp directory exists
        if (!(Test-Path "C:\Temp")) { New-Item -ItemType Directory -Path "C:\Temp" }

        # Download the file
        Invoke-WebRequest -Uri $sourceURL -OutFile $destinationPath

        # Execute the file
        Start-Process -FilePath $destinationPath -Wait -PassThru

    } -ArgumentList $sourceURL, $destinationPath
}

# Cleanup - Remove PSSessions
$sessions | Remove-PSSession
