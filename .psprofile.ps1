$OmpConfigUrl = "https://raw.githubusercontent.com/Anders-Toegersen/OhMyPosh-Config/refs/heads/main/.omp-config.toml"
$OmpConfig = "$env:UserProfile\.omp-config.toml"
if (!(Test-Path($OmpConfig))) {
	Write-Host "Fetching Oh My Posh Config from $($OmpConfigUrl)"
	Invoke-WebRequest $OmpConfigUrl -OutFile $OmpConfig
}
oh-my-posh init pwsh --config $OmpConfig | Invoke-Expression

$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
$CosmosDBEmulator = "$env:ProgramFiles\Azure Cosmos DB Emulator\PSModules\Microsoft.Azure.CosmosDB.Emulator"
if (Test-Path($CosmosDBEmulator)) {
  Import-Module "$CosmosDBEmulator"
}

Import-Module Terminal-Icons

# Aliases
function Start-StorageExplorer { Start-Process -FilePath "C:\Program Files (x86)\Microsoft Azure Storage Explorer\StorageExplorer.exe" }
function Start-DockerDesktop { Start-Process -FilePath "C:\Program Files\Docker\Docker\Docker Desktop.exe" }
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