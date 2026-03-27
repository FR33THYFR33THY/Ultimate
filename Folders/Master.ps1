# ================================
# Gameshler Ultimate Windows Optimizer
# ================================

# ---------- CONFIG ----------
$Repo        = "gameshler/Ultimate-Windows-Optimization-Guide"
$Branch      = "dev"
$InstallDir  = Join-Path $env:USERPROFILE "Downloads\UWOG"
$TempDir     = Join-Path $env:TEMP ("uwog-" + [guid]::NewGuid())
$ZipPath     = "$TempDir.zip"
$CommonScript = Join-Path $InstallDir "Folders\CommonScript.ps1"

# ---------- GLOBALS ----------
$global:ScriptRoot = $null
Set-Variable -Name CommonScript -Value $CommonScript -Scope Global

# ---------- FUNCTIONS ----------

function Test-IsAdmin {
  $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
  $principal = New-Object Security.Principal.WindowsPrincipal($identity)
  return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Restart-AsAdmin {
  param ($ScriptPath)

  Start-Process powershell `
    -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`"" `
    -Verb RunAs

  exit
}

function Invoke-Bootstrap {

  Write-Host "`nDownloading repository..." -ForegroundColor Cyan

  try {
    Invoke-WebRequest -Uri "https://github.com/$Repo/archive/refs/heads/$Branch.zip" `
      -OutFile $ZipPath -UseBasicParsing

    Write-Host "Extracting..." -ForegroundColor Cyan

    Expand-Archive -Path $ZipPath -DestinationPath $TempDir -Force

    $ExtractedDir = Join-Path $TempDir "Ultimate-Windows-Optimization-Guide-$Branch"

    if (-not (Test-Path $ExtractedDir)) {
      throw "Extraction failed."
    }

    Write-Host "Installing to $InstallDir..." -ForegroundColor Cyan

    Remove-Item $InstallDir -Recurse -Force -ErrorAction SilentlyContinue
    Move-Item $ExtractedDir $InstallDir

    $MasterPath = Join-Path $InstallDir "Folders\Master.ps1"

    if (-not (Test-Path $MasterPath)) {
      throw "Master.ps1 not found."
    }

    Write-Host "Launching..." -ForegroundColor Green

    Start-Process powershell `
      -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$MasterPath`"" `
      -Verb RunAs

  } catch {
    Write-Host "Error: $_" -ForegroundColor Red
  } finally {
    Remove-Item $ZipPath -Force -ErrorAction SilentlyContinue
    Remove-Item $TempDir -Recurse -Force -ErrorAction SilentlyContinue

  }

  exit
}

function Initialize-Environment {

  $Host.UI.RawUI.WindowTitle = "Gameshler Ultimate-Windows-Optimization-Guide"
  $Host.UI.RawUI.BackgroundColor = "Black"
  $Host.PrivateData.ProgressBackgroundColor = "Black"
  $Host.PrivateData.ProgressForegroundColor = "White"
  Clear-Host

  $global:ScriptRoot = $PSScriptRoot
}

function Cleanup {
  Write-Host "`nCleaning up..." -ForegroundColor Yellow

  $choice = Read-Host "Delete installation files in $InstallDir? [y/N]"
  if ($choice -match '^[Yy]$') {
    Remove-Item $InstallDir -Recurse -Force -ErrorAction SilentlyContinue
  }
}

# ---------- MENU SYSTEM ----------

function Get-Directories {
  Get-ChildItem -Path $global:ScriptRoot -Directory |
    Where-Object { -not $_.Name.StartsWith('.') }
}

function Show-Menu {

  $asciiArt = @"
______                          __    __             ____             __
/ ____/___ _____ ___  ___  _____/ /_  / /__  _____   / __ \____ ______/ /__
/ / __/ __ `/ __ `__ \/ _ \/ ___/ __ \/ / _ \/ ___/  / /_/ / __ `/ ___/ //_/
/ /_/ / /_/ / / / / / /  __(__  ) / / / /  __/ /     / ____/ /_/ / /__/ ,<
\____/\__,_/_/ /_/ /_/\___/____/_/ /_/_/\___/_/     /_/    \__,_/\___/_/|_|
"@

  while ($true) {

    Clear-Host
    Write-Host $asciiArt -ForegroundColor Magenta
    Write-Host "-----------------------------------------------" -ForegroundColor Green
    Write-Host "Select an option:`n" -ForegroundColor Green

    $directories = Get-Directories

    for ($i = 0; $i -lt $directories.Count; $i++) {
      $name = $directories[$i].Name -replace '^\d+\s*'
      Write-Host "$($i+1). $name" -ForegroundColor Cyan
    }

    Write-Host "0. Exit" -ForegroundColor Red
    Write-Host "-----------------------------------------------" -ForegroundColor Green

    $choice = Read-Host ">"

    if ($choice -eq "0") {
      exit
    }

    if ($choice -match '^\d+$' -and [int]$choice -le $directories.Count) {
      Show-FilesInDirectory -Directory $directories[[int]$choice - 1]
    } else {
      Write-Host "Invalid choice." -ForegroundColor Red
      Start-Sleep 1
    }
  }
}

function Show-FilesInDirectory {
  param ([System.IO.DirectoryInfo]$Directory)

  while ($true) {

    $files = Get-ChildItem -Path $Directory.FullName -File |
      Where-Object { -not $_.Name.StartsWith('.') } |
      Sort-Object Name

    Clear-Host
    Write-Host "Directory: $($Directory.Name -replace '^\d+\s*')`n" -ForegroundColor Yellow

    for ($i = 0; $i -lt $files.Count; $i++) {
      $name = $files[$i].Name -replace '^\d+\s*'
      Write-Host "$($i+1). $name" -ForegroundColor Cyan
    }

    Write-Host "0. Back" -ForegroundColor Red
    Write-Host "-----------------------------------------------" -ForegroundColor Yellow

    $choice = Read-Host ">"

    if ($choice -eq "0") {
      return
    }

    if ($choice -match '^\d+$' -and [int]$choice -le $files.Count) {
      $file = $files[[int]$choice - 1]

      Clear-Host
      Write-Host "Running $($file.Name)...`n" -ForegroundColor Green

      try {
        & $file.FullName
      } catch {
        Write-Host "Error: $_" -ForegroundColor Red
      }

    } else {
      Write-Host "Invalid choice." -ForegroundColor Red
      Start-Sleep 1
    }
  }
}

if (-not $MyInvocation.MyCommand.Path) {
  Invoke-Bootstrap
}

if (-not (Test-IsAdmin)) {
  Restart-AsAdmin -ScriptPath $MyInvocation.MyCommand.Path
}

Initialize-Environment

try {
  Show-Menu
} finally {
  Cleanup
}
