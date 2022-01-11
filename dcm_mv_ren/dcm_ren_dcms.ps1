#   Script Name: Rename Files inside Folder
#        Author: Matthew Tucker
#  Date Created: 1/10/2022
# Date Modified: 1/10/2022
#   Description: This script takes all files within the target folder and renames them entirely
#                Utilizing multiple variables to get the correct extension and increment the names

############################################################
#################### Edit Variables Here ###################
############################################################
# target folder for files you want renamed
$target_fold_loc="C:\Users\mtuck\Documents\Files\programming\batch\comp_scripts\shell_batch_log\shutdown_logs_old"
# confirm look for bad file extension specifically to rename  (enable = 1, disable = 0)
# Enabling (1) this setting tells the script to rename only those files with the bad extension
$SetFileBadExt=1
# bad file extension you want the script to target for renaming
# This is only used if the $SetFileBadExt above is enabled (1)
$bad_ext="dcm"
# The file extension you want the files to be renamed too
$good_ext="xml"
############################################################
################# End Edit Variables Here ##################
############################################################

if($SetFileBadExt -eq 1){
    $nr = 1
    Get-ChildItem -path $target_fold_loc -Recurse -Include "*.$bad_ext" | ForEach-Object{Rename-Item $_ -NewName ('MyFile{0}.{1}' -f $nr++, $good_ext)}
}
else {
    Get-ChildItem -path $target_fold_loc -Recurse | ForEach-Object{Rename-Item $_ -NewName ('MyFile{0}.{1}' -f $nr++, $good_ext)}
}

pause