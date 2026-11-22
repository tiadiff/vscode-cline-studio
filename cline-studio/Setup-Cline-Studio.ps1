param(
    [switch]$AlsoInstallInMainVSCode
)

$ErrorActionPreference = "Stop"
$ScriptDir = $PSScriptRoot
$DataDir = Join-Path $ScriptDir "data"
$UserDir = Join-Path $DataDir "User"
$ExtDir = Join-Path $ScriptDir "extensions"
$ConfigDir = Join-Path $ScriptDir "config"
$VsixFile = Join-Path $ScriptDir "cline-fullscreen.vsix"

Write-Host "=========================================="
Write-Host "   Cline Agent Studio - Initial Setup"
Write-Host "=========================================="

# 1. Initialize clean user config from templates
New-Item -ItemType Directory -Force -Path $UserDir | Out-Null
New-Item -ItemType Directory -Force -Path $ExtDir | Out-Null

if (-not (Test-Path (Join-Path $UserDir "settings.json"))) {
    Copy-Item (Join-Path $ConfigDir "settings.json") (Join-Path $UserDir "settings.json") -Force
    Write-Host "[OK] Initialized isolated settings.json"
}
if (-not (Test-Path (Join-Path $UserDir "keybindings.json"))) {
    Copy-Item (Join-Path $ConfigDir "keybindings.json") (Join-Path $UserDir "keybindings.json") -Force
    Write-Host "[OK] Initialized isolated keybindings.json"
}

# 2. Install VSIX into isolated extensions directory
if (Test-Path $VsixFile) {
    Write-Host "[...] Installing Cline Studio extension into isolated profile..."
    & code --user-data-dir $DataDir --extensions-dir $ExtDir --install-extension $VsixFile --force
    if ($AlsoInstallInMainVSCode) {
        Write-Host "[...] Installing Cline Studio extension into main VS Code..."
        & code --install-extension $VsixFile --force
    }
} else {
    Write-Warning "cline-fullscreen.vsix not found in $ScriptDir. Download it from Releases or build from source."
}

# 3. Create Desktop shortcut with custom icon
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $ScriptDir "Create-Desktop-Shortcut.ps1")

Write-Host "[DONE] Setup complete. Launch 'Cline Agent Studio' from your Desktop."
