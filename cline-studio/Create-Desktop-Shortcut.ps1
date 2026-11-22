$WshShell = New-Object -ComObject WScript.Shell
$Desktop = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
$ShortcutPath = Join-Path -Path $Desktop -ChildPath "Cline Agent Studio.lnk"

$ScriptDir = $PSScriptRoot
$TargetVbs = Join-Path -Path $ScriptDir -ChildPath "Launch-Silent.vbs"
$CustomIcon = Join-Path -Path $ScriptDir -ChildPath "assets\cline-studio.ico"

$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "wscript.exe"
$Shortcut.Arguments = "`"$TargetVbs`""
$Shortcut.WorkingDirectory = $ScriptDir
$Shortcut.Description = "Cline Agent Studio - Minimal Dark AI Workspace"

if (Test-Path $CustomIcon) {
    $Shortcut.IconLocation = "$CustomIcon,0"
} elseif (Test-Path "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe") {
    $Shortcut.IconLocation = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe,0"
}

$Shortcut.Save()
Write-Host "[OK] Desktop shortcut created: $ShortcutPath"
