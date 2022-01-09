#   Script Name: Delete Older Than
#        Author: Matthew Tucker
#  Date Created: 1/8/2022
# Date Modified: 1/8/2022
#   Description: This script considers settings in a ini file and utilizes those settings to delete
#                Files based on their last date modified.

#Auto Generate the path to the INI based on where the script has been setup.
#$executingScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

############################################################
#################### Edit Variables Here ###################
############################################################
# folder to check files for and delete
$del_folder="C:\Users\mtuck\Documents\Files\programming\batch\comp_scripts\shell_batch_log\shutdown_logs"
# Any files that haven't been touched since this many days below will be deleted
$DeleteDays=15
# If you want the delete script to filter files by extension (0 = Disable, 1 = Enable)
# This might need to be disabled (0) to deal with file types of "FILE" whereas, they do not have an extension assigned to them.
$SetUseExtension=0
# Will only be useful with SetUseExtension enabled (1)
# list file extension of file type you want removed (without the period in front)
# EX: FilExt=XML, FileExt=xml, FileExt=txt, FileExt=* (* = Wildcard for any extension)
$FileExt="txt"
# Whether or not you want to go into subfolders to also delete (0 = Disable, 1 = Enable)
$SetRecursion=1

############################################################
################# End Edit Variables Here ##################
############################################################


## Deleting Portion of the Script
$CurrentDate = Get-Date
$DatetoDelete = $CurrentDate.AddDays(-$DeleteDays)

if($SetUseExtension -eq 1){
    if($SetRecursion -eq 0){
        #delete all files in the direct folder with the file extension chosen
        Get-ChildItem -Path $del_folder *.$FileExt -force | where-object {$_.LastWriteTime -le $DatetoDelete} | remove-item -force;
    }
    else{
        #delete all files in the direct folder and sub-folders with the file extension chosen
        Get-ChildItem -Path $del_folder *.$FileExt -force -recurse | where-object {$_.LastWriteTime -le $DatetoDelete} | remove-item -force;
        #-Include "*.$ext"
    }
    
}
else{
    if($SetRecursion -eq 0){
        #delete all files in the direct folder no matter the file extension
        Get-ChildItem -Path $del_folder * -force | where-object {$_.LastWriteTime -le $DatetoDelete} | remove-item -force;
    }
    else{
        #delete all files in the direct folder and sub-folders no matter the file extension
        Get-ChildItem -Path $del_folder * -force -recurse | where-object {$_.LastWriteTime -le $DatetoDelete} | remove-item -force;

    }
    
}
#uncomment the "pause" below for testing purposes
#pause