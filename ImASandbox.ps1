function Write-IASLOG($type, $text) {
  $LogType = ($type).ToUpper()
  $LogText = $text
  Write-Host "[$LogType] $LogText"
}

if ((Get-MpPreference).DisableRealTimeMonitoring) {
  Write-IASLOG "error" "AV is enabled. Disable Windows Defender and try again"
  Exit
}

$UserName = $env:UserName

$CurrentWorkingDir = (Get-Location).Path

#------ create VM hints

# create some vbox artifacts
New-Item -Path 'C:\Windows\System32\vboxhook.dll' -ItemType File
Write-IASLOG "info" "Created vboxhook.dll file in System32"

# New-Item -Path 'HKLM:\SYSTEM\ControlSet001\Services' -ItemType 'VboxSF'
New-Service -Name "VboxSF" -BinaryPathName "C:\Windows\System32\calc.exe"
Write-IASLOG "info" "Created VboxSF service"

#------ create fake processes

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
  Write-IASLOG "info" "Created fake process at startup: $pName"
}