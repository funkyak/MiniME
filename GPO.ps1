# Define GPO Name
$GPOName = "Disable CMD & PowerShell"

# Import Active Directory and Group Policy modules (if not already loaded)
Import-Module ActiveDirectory
Import-Module GroupPolicy

# Create a new GPO
New-GPO -Name $GPOName | Out-Null

# Get the GPO object
$GPO = Get-GPO -Name $GPOName

# Set policies to disable cmd.exe and PowerShell
# Disables Command Prompt
Set-GPRegistryValue -Name $GPOName -Key "HKCU\Software\Policies\Microsoft\Windows\System" -ValueName "DisableCMD" -Type DWord -Value 1

# Restrict PowerShell execution policy
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows\PowerShell" -ValueName "EnableScripts" -Type DWord -Value 0
Set-GPRegistryValue -Name $GPOName -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows\PowerShell" -ValueName "ExecutionPolicy" -Type String -Value "Restricted"

# Link GPO to Domain
$DomainDN = (Get-ADDomain).DistinguishedName
New-GPLink -Name $GPOName -Target "DC=$DomainDN"

# Apply security filtering: Remove "Authenticated Users" and allow only "Domain Admins"
$GPO | Set-GPPermission -TargetName "Authenticated Users" -TargetType Group -PermissionLevel None
$GPO | Set-GPPermission -TargetName "Domain Admins" -TargetType Group -PermissionLevel GpoApply

Write-Host "GPO '$GPOName' has been created and linked to the domain, restricting CMD and PowerShell for all users except Domain Admins."
