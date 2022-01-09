#   Script Name: Delete Older Than
#        Author: Matthew Tucker
#  Date Created: 1/8/2022
# Date Modified: 1/8/2022
#   Description: This script considers settings in a ini file and utilizes those settings to delete
#                Files based on their last date modified.
#        Credit:
#               Scripts: Get-IniContent
#                Userid: beruic
#                   URL: https://gist.github.com/beruic/1be71ae570646bca40734280ea357e3c
#                

#Auto Generate the path to the INI based on where the script has been setup.
$executingScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$iniPath = Join-Path $executingScriptDirectory "del_older_than_cnf.ini"
$getiniPath = Join-Path $executingScriptDirectory "get_ini_content.ps1"


#$iniContent = Get-IniContent $iniPath
$iniContent = @{}
$iniContent = Invoke-Expression -Command "$getiniPath $iniPath"
#Write-Output $iniContent["Script Variables"]
Write-Output $iniContent["System Variables"]
pause
Write-Output $iniContent["Script Variables"]["DeleteDays"]
## Deleting Portion of the Script
$CurrentDate = Get-Date
$DatetoDelete = $CurrentDate.AddDays(-$iniContent["Script Variables"]["DeleteDays"])
#TODO: Get the filepath directory to output correctly so it doesn't say the '"C' doesn't exist
$filepath = $iniContent["System Variables"]["1st_Folder"]
$filepath = $filepath.toString()
#$filepath = "C:\Users\mtuck\Documents\Files\programming\batch\comp_scripts\shell_batch_log\shutdown_logs\"
#$ext = $iniContent["Script Variables"]["FileExt"]
Write-Output $filepath
pause

if($iniContent["Script Variables"]["SetUseExtension"] -eq 1){
    if($iniContent["Script Variables"]["SetRecursion"] -eq 0){
        Get-ChildItem -Path $iniContent["System Variables"]["1st_Folder"] *.$iniContent["Script Variables"]["FileExt"] | ForEach-Object { Remove-Item -Path $_.FullName | Where-Object { $_.LastWriteTime -lt $DatetoDelete } }
    }
    else{
        #Get-ChildItem -Recurse -Path $iniContent["System Variables"]["1st_Folder"] *.$iniContent["Script Variables"]["FileExt"] | ForEach-Object { Remove-Item -Path $_.FullName | Where-Object { $_.LastWriteTime -lt $DatetoDelete } }
        Get-ChildItem -Path $filepath
        #-Include "*.$ext"
    }
    
}
else{
    if($iniContent["Script Variables"]["SetRecursion"] -eq 0){
        Get-ChildItem -Path $iniContent["System Variables"]["1st_Folder"] * -Recurse | ForEach-Object { Remove-Item -Path $_.FullName | Where-Object { $_.LastWriteTime -lt $DatetoDelete } }
    }
    else{
        Get-ChildItem -Recurse -Path $iniContent["System Variables"]["1st_Folder"] * | ForEach-Object { Remove-Item -Path $_.FullName | Where-Object { $_.LastWriteTime -lt $DatetoDelete } }
    }
}
#Get-ChildItem $iniContent["System Variaables"]["1st_Folder"] -Recurse | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item

pause