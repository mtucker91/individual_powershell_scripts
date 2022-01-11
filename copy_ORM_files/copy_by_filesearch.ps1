#   Script Name: Copy By FileSearch
#        Author: Matthew Tucker
#  Date Created: 1/4/2022
# Date Modified: 1/10/2022
#   Description: This script compare the search terms list provided (inside the same directory)
#                to a list of full file pathways to confirm if any part of the file pathway matches
#                a specific search term.           


$executingScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Write-Output $output
############################################################
#################### Edit Variables Here ###################
############################################################
$dest_folder = "D:\End\Destination" #ending location you want the files you need copied too

# edit only the filename and extension at the end 
$scriptPath = Join-Path $executingScriptDirectory "search_terms.txt" # full path for file that houses search_terms
$filelistPath = Join-Path $executingScriptDirectory "filepath_output.txt" # full path for file that has the list of full-file pathways to search through
############################################################
################# End Edit Variables Here ##################
############################################################

# Assigns the arrays based upon the contents of the files
[string[]]$list_search_terms = Get-Content -Path $scriptPath
[string[]]$list_filepaths = Get-Content -Path $filelistPath
$output = $list_search_terms.Count.toString() + " total search terms found"
$mtch_fnd = 0
$overall_ttl = 0

foreach($filepath in $list_filepaths) {
    foreach($search_term in $list_search_terms) {
        #Write-Output $file.FullName
        if($filepath -match $search_term) {
            Copy-Item -Path $filepath -Destination $dest_folder -Force
            $mtch_fnd++   
        }
    }

    if($mtch_fnd -gt 0) {
        $output = "total of " + $mtch_fnd.toString() + " matches found for " + $search_term.toString()  
        Write-Output $output
        
    }
    $overall_ttl = $overall_ttl + $mtch_fnd
    $mtch_fnd = 0
}

$output = $overall_ttl.toString() +  " Total overall matches found"
Write-Output $output

Start-Sleep -Seconds 600