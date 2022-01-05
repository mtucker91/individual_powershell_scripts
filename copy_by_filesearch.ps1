$executingScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent


Write-Output $output
######################### EDIT VARIABLES HERE #############################
$dest_folder = "D:\End\Destination" #ending location you want the files you need copied too

# edit only the filename and extension at the end 
$scriptPath = Join-Path $executingScriptDirectory "search_terms.txt" # full path for file that houses search_terms
$datelistPath = Join-Path $executingScriptDirectory "date_list.txt" # full path for file that has the list of preformmatted dates by YYYYMMDD
$filelistPath = Join-Path $executingScriptDirectory "filepath_output.txt" # full path for file that has the list of full-file pathways to search through
###########################################################################

# Assigns the arrays based upon the contents of the files
[string[]]$list_search_terms = Get-Content -Path $scriptPath
[string[]]$list_dates = Get-Content -Path $datelistPath
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