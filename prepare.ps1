$unikeyRootUrl = "https://www.unikey.org/assets/release/"
$unikey86FileName = "unikey43RC5-200929-win32.zip"
$unikey64FileName = "unikey43RC5-200929-win64.zip"

$unikey86Url = $unikeyRootUrl + $unikey86FileName
$unikey64Url = $unikeyRootUrl + $unikey64FileName

$solutionRoot = $(Get-Location)
$appRoot = $(Get-Location).Path + "\\src\\UnikeyVietnameseKeyboard.Launcher\\Apps"
$unikey86AppRoot = $appRoot + "\\x86\\"
$unikey64AppRoot = $appRoot + "\\x64\\"

if (!(Test-Path $appRoot)) {
    New-Item -ItemType "Directory" -Force -Path $appRoot
}

if (!(Test-Path $unikey86AppRoot)) {
    New-Item -ItemType "Directory" -Force -Path $unikey86AppRoot
}

if (!(Test-Path $unikey64AppRoot)) {
    New-Item -ItemType "Directory" -Force -Path $unikey64AppRoot
}

Invoke-WebRequest -Uri $unikey86Url -OutFile $unikey86FileName
Expand-Archive -Path $unikey86FileName -DestinationPath $unikey86AppRoot -Force
Remove-Item $unikey86FileName -Force

Invoke-WebRequest -Uri $unikey64Url -OutFile $unikey64FileName
Expand-Archive -Path $unikey64FileName -DestinationPath $unikey64AppRoot -Force
Remove-Item $unikey64FileName -Force

Set-Location $solutionRoot