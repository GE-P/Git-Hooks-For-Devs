$customHooksPath = "hooks_files_windows"
$hooksToRemove = @("commit-msg", "post-commit", "pre-commit", "prepare-commit-msg", "unins000.exe", "unins000.dat")

$RED = [ConsoleColor]::Red
$GREEN = [ConsoleColor]::Green
$BLUE = [ConsoleColor]::Blue
$ENDCOLOR = [ConsoleColor]::White

function Remove-Hooks {
    param (
        [string]$gitHooksPath
    )

    if (Test-Path $gitHooksPath -PathType Container) {
        foreach ($hookName in $hooksToRemove) {
            $hookPath = Join-Path -Path $gitHooksPath -ChildPath $hookName
            if (Test-Path $hookPath -PathType Leaf) {
                Remove-Item $hookPath -Force
                Write-Host "Removed hook: $hookPath" -ForegroundColor Blue
            }
        }
    }
}

function Copy-CustomHooks {
    param (
        [string]$gitHooksPath
    )

    if (Test-Path $gitHooksPath -PathType Container) {
        Copy-Item $customHooksPath\* $gitHooksPath -Force

        Write-Host "Copied custom hooks to: $gitHooksPath" -ForegroundColor Green
    }
}

Write-Host "   __ __          __          _          __       ____"
Write-Host "  / // /__  ___  / /__ ___   (_)__  ___ / /____ _/ / /__ ____"
Write-Host " / _  / _ \/ _ \/  '_/(_-<  / / _ \(_-</ __/ _ \`/ / / -_) __/"
Write-Host "/_//_/\___/\___/_/\_\/___/ /_/_//_/___/\__/\_,_/_/_/\__/_/      /v1.0.0/"

$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host ""
    Write-Host "----> Is user administrator: " -NoNewline
    Write-Host "no" -ForegroundColor Red
    Write-Host "Please run this script as an administrator." -ForegroundColor Red
    exit
} else {
    Write-Host ""
    Write-Host "----> Is user administrator: " -NoNewline
    Write-Host "yes" -ForegroundColor Green
}

$gitTemplatesPath = "C:\Program Files\Git\mingw64\share\git-core\templates\hooks"
if (Test-Path $gitTemplatesPath -PathType Container) {
    Remove-Hooks -gitHooksPath $gitTemplatesPath
    Copy-CustomHooks -gitHooksPath $gitTemplatesPath
}

Write-Host ""
Write-Host "----> Custom hooks installed successfully!"
Write-Host ""

$updateExisting = Read-Host "Do you want to update existing project hooks? (y/n): "
if ($updateExisting -eq "y") {
    $hooksUpdaterScript = Join-Path -Path $PSScriptRoot -ChildPath "hooks_updater.ps1"
    Start-Process -Wait -FilePath "powershell" -ArgumentList "-File", "$hooksUpdaterScript"
}
