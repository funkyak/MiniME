$users = Get-Content .\enable_ad.txt
foreach ($user in $users) { 
    Enable-ADAccount -Identity $user -Confirm:$false
    Write-Host "$user Enabled"
}
Write-Host "Complete"
