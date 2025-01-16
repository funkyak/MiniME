Get-ADUser -Filter * -Properties * | 
    Select-Object SamAccountName | 
    #Uncomment if wanting to exclude Administrator
    #Where-Object { $_.SamAccountName -notlike "Administrator" } | 
    Out-File .\user_ad.txt

# Trim extra whitespace in the file
$content = Get-Content .\user.txt
$content | ForEach-Object { $_.TrimEnd() } | Set-Content .\user.txt
