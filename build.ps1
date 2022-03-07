$env:Path += ";C:\Program Files (x86)\Windows Kits\10\bin\10.0.22000.0\x64\"
$solutionPath = $(Get-Location).Path
$sourcePath = $solutionPath + "\src"
$appVDrive = $sourcePath + ".\VFS\AppVPackageDrive"

$unikeyReleaseRoot = "https://www.unikey.org/assets/release/"
$unikey64FileName = "unikey43RC5-200929-win64.zip"
# $unikey86FileName = "unikey43RC5-200929-win32.zip"

Set-Location $sourcePath
$unikeyFileName = $unikey64FileName
Invoke-WebRequest -Uri $unikeyReleaseRoot$unikeyFileName -OutFile $unikeyFileName
Expand-Archive -Path $unikeyFileName -DestinationPath $appVDrive --Force
Remove-Item $unikeyFileName

Set-Location $sourcePath
MakePri new /pr . /cf "..\config\priconfig.xml"

Set-Location $solutionPath
New-Item -Path "AppPackages" -ItemType "Directory" -Force
MakeAppX pack /d ".\src" /p ".\AppPackages\UnikeyVietnameseKeyboard64.msix"

Set-Location $solutionPath