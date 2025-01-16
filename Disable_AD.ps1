$users = Get-Content .\disabled_ad.txt
foreach ($user in $users) { 
    Disable-ADAccount -Identity $user -Confirm:$false
    Write-Host "$user Disabled"
}
Write-Host "Complete"
