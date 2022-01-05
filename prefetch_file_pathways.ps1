#   Script Name: Prefetch File Pathways
#        Author: Matthew Tucker
#  Date Created: 1/4/2022
# Date Modified: 1/4/2022
#   Description: This script will find all the files in a particular directory and subdirectories where
#                the filename ends in _PASS.HL7 and output the full-path of the file to a text file

#                

######################### EDIT VARIABLES HERE #############################

$initsearchpath = "D:\HL7InLog" #location of the files you want to sift through
$dest_folder = "D:\ORMS_TO_RESEND" #ending location you want the files you need copied too
$output_filename = "filepath_output.txt"
$date_list_filename = "date_list.txt"

###########################################################################

$executingScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$datelistPath = Join-Path $executingScriptDirectory $date_list_filename # makes full path for file that has the list of preformmatted dates by YYYYMMDD
$outputfilePath = Join-Path $executingScriptDirectory $output_filename # makes full path for file that has the list of preformmatted dates by YYYYMMDD
# Assigns the arrays based upon the contents of the files
[string[]]$list_dates = Get-Content -Path $datelistPath

foreach ($date in $list_dates){
    # Note: As of the making of this script, the directory pathways went
    # "D:\HL7InLog\YYYYMMDD\PASS_OR_FAIL\MSG_TYPE" Since I knew how I wanted to navigate I made
    # multiple pathway variables to string together before putting it in the Get-ChildItem method
    $searchpath = $initsearchpath + "\" + $date + "\PASS\ORM\"
    #find all entries with _PASS.HL7 in the drilled-down directory and output them to a file named filepath_output.txt
    Get-ChildItem -Path $searchpath -Recurse -Include "*_PASS.HL7" | ForEach-Object { $_.FullName } >> $outputfilePath
}

Write-Output "Script Completed"
Start-Sleep -Seconds 600