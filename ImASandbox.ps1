function IAS-Log($type, $text) {
  $LogType = ($type).ToUpper()
  $LogText = $text
  Write-Host "[$LogType] $text"
}

if ((Get-MpPreference).DisableRealTimeMonitoring) {
  IAS-Log "error" "AV is enabled. Disable Windows Defender and try again"
  Exit
}

$UserName = $env:UserName

$CurrentWorkingDir = (Get-Location).Path

# create vbox hints

# create some vbox artifacts
New-Item -Path 'C:\Windows\System32\vboxhook.dll' -ItemType File
# New-Item -Path 'HKLM:\SYSTEM\ControlSet001\Services' -ItemType 'VboxSF'
New-Service -Name "VboxSF" -BinaryPathName "C:\Windows\System32\calc.exe"

# fake processes that do nothing 
Add-MpPreference -ExclusionPath "$CurrentWorkingDir\bin"

$pNames = "Wireshark.exe", 
          "ProcessHacker.exe", 
          "WinDBG.exe",
          "procmon64.exe",
          "VMwareService.exe",
          "VMwareTray.exe",
          "VMwareUser.exe"

foreach ($pName in $pNames) {
  $pPath = "C:\Users\$UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\$pName"
  Add-MpPreference -ExclusionPath $pPath
  Copy-Item -Path ".\bin\donothing.exe" -Destination $pPath
  IAS-Log "INFO" "Created fake process at startup: $pName"
}