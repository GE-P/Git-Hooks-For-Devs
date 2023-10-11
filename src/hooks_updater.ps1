$list_path = ("C:\Users", "D:\")
# $rootPath = "C:\"
$customHooksPath = "hooks_files_windows"
$hooksToRemove = @("commit-msg", "post-commit", "pre-commit", "prepare-commit-msg", "unins000.exe", "unins000.dat")

$global:updatedCount = 0

$GREEN = [ConsoleColor]::Green
$BLUE = [ConsoleColor]::Blue
$ENDCOLOR = [ConsoleColor]::White
function Remove-Hooks {
    param (
        [string]$gitHooksPath,
        [string]$currentPath
    )

    if (Test-Path $gitHooksPath -PathType Container) {
        $foundGitProject = $false

        foreach ($hookName in $hooksToRemove) {
            $hookPath = Join-Path -Path $gitHooksPath -ChildPath $hookName
            if (Test-Path $hookPath -PathType Leaf) {
                if (!$foundGitProject) {
                    Write-Host ""
                    Write-Host "Found git project: $currentPath/.git"
                    $foundGitProject = $true
                }
                
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
        $global:updatedCount++
    }
}

function Find-AndCopyHooks {
    param (
        [string]$currentPath
    )

    if (Test-Path (Join-Path -Path $currentPath -ChildPath ".git") -PathType Container) {
        $gitHooksPath = Join-Path -Path $currentPath -ChildPath ".git\hooks"
        Remove-Hooks -gitHooksPath $gitHooksPath -currentPath $currentPath
        Copy-CustomHooks -gitHooksPath $gitHooksPath
    }

    $items = Get-ChildItem -Path $currentPath -Force -ErrorAction SilentlyContinue | Where-Object {
        -not ($_ -is [System.IO.DirectoryInfo] -and $_.Name -eq '$RECYCLE.BIN')
    }

    foreach ($item in $items) {
        if ($item.PSIsContainer -and (-not ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint))) {
            Find-AndCopyHooks -currentPath $item.FullName
        }
    }
}

Write-Host "   __ __          __                       __     __"
Write-Host "  / // /__  ___  / /__ ___   __ _____  ___/ /__ _/ /____ ____"
Write-Host " / _  / _ \/ _ \/  '_/(_-<  / // / _ \/ _  / _ \`/ __/ -_) __/"
Write-Host "/_//_/\___/\___/_/\_\/___/  \_,_/ .__/\_,_/\_,_/\__/\__/_/      /v1.0.0/"
Write-Host "                               /_/                           "

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

foreach ($rootPath in $list_path) {
Find-AndCopyHooks -currentPath $rootPath    
}

Write-Host ""
Write-Host ("----> A total of {0} projects were found and updated with the latest hooks, happy coding !" -f $global:updatedCount)
Write-Host ""
