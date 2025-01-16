$users = Get-Content .\user_add_ad.txt
foreach ($user in $users) {
    New-ADUser -Name $user
    Write-Host "$user Created"
}
Write-Host "Complete"
