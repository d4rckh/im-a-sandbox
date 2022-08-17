# ImASandbox

Make your machine look like a sandbox/vm. This *might* harden your computer against infections.

## Features

- Have fake processes like `Wireshark.exe`, `ProcessHacker.exe`, etc. be created at startup
- Create VM software artifacts like dlls and services

## Installing

1. Open Powershell as Administrator
2. Disable Windows Defender's real time protection
3. Clone the GitHub repostiroy
4. Run `.\ImASandox.ps1`
5. Save the script output to a file
6. Enable Windows Defender back

## Removing

Currently, there isn't a way to revert the changes made. Fortunately, the script logs every change to the console, making it easy for you to track what got modified.