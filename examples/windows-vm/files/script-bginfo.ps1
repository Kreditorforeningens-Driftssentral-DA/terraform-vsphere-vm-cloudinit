#ps1_sysnative
$URL = "https://download.sysinternals.com/files/BGInfo.zip"
$DIR = "C:\Program Files\Bginfo"
New-Item $DIR -ItemType Directory
Invoke-WebRequest -Uri $URL -Outfile "$DIR\BGInfo.zip"
Expand-Archive -Confirm:$false -Force:$true "$DIR\BGInfo.zip" $DIR
Remove-Item "$DIR\BGInfo.zip"