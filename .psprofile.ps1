$OmpConfig = "$env:UserProfile\.omp-config.toml"
$OmpCache = "$env:UserProfile\.omp-init.ps1"

if (!(Test-Path $OmpConfig)) {
    Invoke-WebRequest "https://raw.githubusercontent.com/Anders-Toegersen/OhMyPosh-Config/refs/heads/main/.omp-config.toml" -OutFile $OmpConfig
    Remove-Item $OmpCache -ErrorAction SilentlyContinue
}

if (!(Test-Path $OmpCache) -or (Get-Item $OmpConfig).LastWriteTime -gt (Get-Item $OmpCache).LastWriteTime) {
    oh-my-posh init pwsh --config $OmpConfig | Set-Content $OmpCache
}
. $OmpCache

function global:refreshenv {
    $path = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
    if (Test-Path $path) {
        Import-Module $path -Global
        refreshenv @Args
    }
}

Import-Module Terminal-Icons
Import-Module CompletionPredictor
Set-PSReadLineOption -PredictionViewStyle ListView -PredictionSource Plugin

# Aliases
function global:Start-CosmosDbEmulator { Start-Process -FilePath "$env:ProgramFiles\Azure Cosmos DB Emulator\Microsoft.Azure.Cosmos.Emulator.exe" }
function global:Start-StorageExplorer { Start-Process -FilePath "$env:ProgramFiles\Microsoft Azure Storage Explorer\StorageExplorer.exe" }
function global:Start-DockerDesktop { Start-Process -FilePath "$env:ProgramFiles\Docker\Docker\Docker Desktop.exe" }
function global:Edit-Notepad { notepad++ -multiInst -notabbar -nosession -noPlugin @Args }; Set-Alias -Name edit -Value Edit-Notepad -Scope Global
function global:Goto-DevFolder { Set-Location -Path C:\Dev }; Set-Alias -Name cdd -Value Goto-DevFolder -Scope Global
function global:List-Dir { Get-ChildItem | Format-Wide -Column 4 }; Set-Alias -Name lss -Value List-Dir -Scope Global
function global:GoHome { Set-Location ~ }; Set-Alias -Name "~" -Value GoHome -Scope Global
function global:GoBack { Set-Location - }; Set-Alias -Name ".-" -Value GoBack -Scope Global
function global:GoForward { Set-Location + }; Set-Alias -Name ".+" -Value GoForward -Scope Global
function global:Set-ParentLocation { Set-Location .. }; Set-Alias -Name ".." -Value Set-ParentLocation -Scope Global -Force
function global:GoUp2 { Set-Location ..\.. }; Set-Alias -Name "..." -Value GoUp2 -Scope Global
function global:GoUp3 { Set-Location ..\..\.. }; Set-Alias -Name "...." -Value GoUp3 -Scope Global
function global:GoUp4 { Set-Location ..\..\..\.. }; Set-Alias -Name "....." -Value GoUp4 -Scope Global
function global:GoUp5 { Set-Location ..\..\..\..\.. }; Set-Alias -Name "......" -Value GoUp5 -Scope Global
function global:Dublicate-Terminal { wt -w 0 nt -d . }; Set-Alias -Name dt -Value Dublicate-Terminal -Scope Global

# Completers
Register-ArgumentCompleter -Native -CommandName git -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    $cmd = $commandAst.ToString()
    if ($cmd -match 'git\s+fu\s*') {
        git log --oneline -10 2>$null | ForEach-Object {
            $hash, $message = $_ -split ' ', 2
            [System.Management.Automation.CompletionResult]::new($hash, "$hash - $message", 'ParameterValue', $message)
        }
    }
    elseif ($cmd -match 'git\s+switch\s*') {
        $local = @(git for-each-ref --format='%(refname:short)' refs/heads 2>$null); $all = git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads refs/remotes/origin 2>$null | ? { $_ -and $_ -notmatch '(HEAD|->)' -and $_ -ne 'origin' } | % { $_ -replace '^origin/','' } | Select-Object -Unique; $main = @($all | ? { $_ -match '^(main|master)$' }); ($main + ($all | ? { $_ -notmatch '^(main|master)$' } | Select -First (10 - $main.Count))) | % { $d = if ($_ -in $local) { "`e[32m$_`e[0m" } else { "`e[33m$_`e[0m" }; $t = if ($_ -in $local) { "$_ (local)" } else { "$_ (remote)" }; [System.Management.Automation.CompletionResult]::new($_, $d, 'ParameterValue', $t) }
    }
}
