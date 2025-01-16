$listofusers = Get-Content .\user_ad.txt
foreach ($user in $listofusers) {
    $password = -join ((33..126) | Get-Random -Count 20 | ForEach-Object {[char]$_})
    $newpasswd = ConvertTo-SecureString $password -AsPlainText -Force
    Write-Host "$user, $password"
    Add-Content .\password.txt "$user,$password"
}
Write-Host "Complete" -ForegroundColor Green
