# Define credentials
$username = "Administrator"
$password = "Cool2Pass" | ConvertTo-SecureString -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($username, $password)

# List of remote computers
$computers = @("Server1", "Server2", "Server3")

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

# Run custom commands on all sessions
if ($sessions.Count -gt 0) {
    $result = Invoke-Command -Session $sessions -ScriptBlock {
        # Your custom command here
        Get-Process | Select-Object -First 5
    }
    
    # Display result
    $result
}

# Cleanup - Remove PSSessions
$sessions | Remove-PSSession
