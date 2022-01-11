#   Script Name: Rename Spool Folder
#        Author: Matthew Tucker
#  Date Created: 1/10/2022
# Date Modified: 1/11/2022
#   Description: This script renames the current spool folder to append _old to the end

############################################################
#################### Edit Variables Here ###################
############################################################
# current spool folder location: IMPORTANT TO KEEP THE ENDING BACKSLASH!!!!
$spool_fold_loc="C:\Users\mtuck\Documents\Files\programming\batch\comp_scripts\shell_batch_log\"
#$spool_fold_loc="D:\INFINITT\"
# current name of the spool folder you want to rename
$spool_fold_name="shutdown_logs"
#$spool_fold_name="DcmSpool"
# Any files that haven't been touched since this many days below will be deleted
$appendage="_old"
$inc_num_file = "inc_num.txt"
############################################################
################# End Edit Variables Here ##################
############################################################
$executingScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$incPath = Join-Path $executingScriptDirectory $inc_num_file
if(Test-Path $incPath){
    $rr = Get-Content -Path $incPath
    $rr = [int]$rr
    $rr = $rr + 1
    Set-Content -Path $incPath -Value $rr
}
else{
    New-Item -Path $executingScriptDirectory -Name $inc_num_file -ItemType "file" -Value 1
}
$nr = 1
$spool_fold_ren = $spool_fold_name + $appendage
$full_cur_path = $spool_fold_loc + $spool_fold_name
$full_cur_ren_path = $spool_fold_loc + $spool_fold_ren
## Deleting Portion of the Script
#$CurrentDate = Get-Date
#$DatetoDelete = $CurrentDate.AddDays(-$DeleteDays)

# param (
#     $localPath = "c:\example\latest\"         #"# generally, consider NOT using a trailing \
# )
# Confirm if $spool_fold_name exists
if (Test-Path $full_cur_path) { # if $spool_fold_name exists
    Write-Output " I: $spool_fold_name has been found"
    # Confirm if the folder DcmSpool_old exists already
    if(Test-Path $full_cur_ren_path) { # if DcmSpool_old folder already exists
        #setup a new variable to rename DcmSpool_old to DcmSpool_old_yyyyMMdd
        $spool_dte="$(Split-Path -Leaf $full_cur_ren_path)_$((Get-Date).ToString('yyyyMMdd'))"
        $full_dte_path = $spool_fold_loc + $spool_dte
        if(Test-Path $full_dte_path) { # if the DcmSpool_old_yyyyMMdd already exists
            Write-Output " I: $spool_dte has been found"
            Write-Output " I: Renaming all files in $spool_fold_ren"
            Get-ChildItem -path $full_cur_ren_path -Include "*" -Recurse | ForEach-Object{Rename-Item -Path ($_.FullName) -NewName ("rerun{0}_num{1}{2}" -f $rr, $nr++, $_.extension)}
            Write-Output " I: Moving all files from $spool_fold_ren -> $spool_dte"
            Get-ChildItem -Path $full_cur_ren_path -Include "*" -Recurse | Move-Item -Destination $full_dte_path
        }
        else { # if DcmSpool_old_yyyyMMdd does not exist
            Write-Output " I: $spool_dte does not exist"
            Write-Output " I: Renaming the folder $spool_fold_ren -> $spool_dte"
            Rename-Item -Path $full_cur_ren_path -newName $full_dte_path -Force
        }
        # after the status of files and folder for DcmSpool_old_yyyyMMdd has been confirmed
        Write-Output " I: All other $spool_fold_ren -> $spool_dte operations have completed at this time."
        Write-Output " I: Renaming all Files in $spool_fold_name"
        Get-ChildItem -path $full_cur_path -Include "*" -Recurse | ForEach-Object{Rename-Item -Path ($_.FullName) -NewName ("rerun{0}_num{1}{2}" -f $rr, $nr++, $_.extension)}
        Write-Output " I: Moving all files from $spool_fold_name -> $spool_fold_ren"
        Get-ChildItem -Path $full_cur_path -Include "*" -Recurse | Move-Item -Destination $full_cur_ren_path
        # Note: We already confirmed that the DcmSpool_old already exists so moving files is preferred
        #       Instead of just renaming
    }
    else { # if DcmSpool does not exist
        Write-Output " I: $spool_fold_ren does not exist"
        Write-Output " I: Renaming $spool_fold_name -> $spool_fold_ren"
        Rename-Item -Path $full_cur_path -newName $full_cur_ren_path -Force
        # remake the DcmSpool folder as we know that it was renamed to DcmSpool_old
        New-Item -Path $spool_fold_loc -Name $spool_fold_name -ItemType "directory" | Out-Null
        Break
    }
    
}
else {
    $msg_txt = " E: There was no original folder of $full_cur_path to rename.  This script will stop at this time."
    throw $msg_txt
}


$ConfMoveToRen = Read-Host " User Prompt: Would you like to move back all files from $spool_dte -> $spool_fold_ren ? (Y/N): "

if ($ConfMoveToRen -eq "Y"){
    Write-Output " I: Moving all files from $spool_dte -> $spool_fold_name"
    Get-ChildItem -Path $full_dte_path -Include "*" -Recurse | Move-Item -Destination $full_cur_path
}

Write-Output " I: Script has Completed at this time."
pause