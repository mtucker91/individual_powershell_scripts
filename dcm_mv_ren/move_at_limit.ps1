#   Script Name: Move Files At Limit
#        Author: Matthew Tucker
#  Date Created: 1/11/2022
# Date Modified: 1/12/2022
#   Description: This script moves a certain amount of files from a source directory to a
#                destination directory.  This is done to allow outside programs that would process files
#                in the destination directory time to process them before more files are put in.
#                
#       Credits:
#            Author: ctigeek
#            Script: Start-Sleep function provided inside this script
#               URL: https://gist.github.com/ctigeek/bd637eeaeeb71c5b17f4
############################################################
#################### Edit Variables Here ###################
############################################################

$filespersend = 2
$sourcePath = "C:\Users\mtuck\Documents\Files\programming\batch\comp_scripts\shell_batch_log\shutdown_logs_old"
$destPath = "C:\Users\mtuck\Documents\Files\programming\batch\comp_scripts\shell_batch_log\shutdown_logs"
$sec_wait = 10
$i = 0;
$ext = "dcm"

############################################################
################# End Edit Variables Here ##################
############################################################

function Start-Sleep($seconds) {
    $doneDT = (Get-Date).AddSeconds($seconds)
    while($doneDT -gt (Get-Date)) {
        $secondsLeft = $doneDT.Subtract((Get-Date)).TotalSeconds
        $percent = ($seconds - $secondsLeft) / $seconds * 100
        Write-Progress -Activity "Sleeping" -Status "Sleeping..." -SecondsRemaining $secondsLeft -PercentComplete $percent
        [System.Threading.Thread]::Sleep(500)
    }
    Write-Progress -Activity "Sleeping" -Status "Sleeping..." -SecondsRemaining 0 -Completed
}

function Cnt-Fles($dpath, $ext, $fa){

    $cf = [System.IO.Directory]::GetFiles("$dpath", ".$ext").Count
    $cf = (Get-ChildItem -File -Path $dpath | Measure-Object).Count
    if($cf -le $fa){
        $r = 1
    }
    else{
        $r = 0
    }

    return $r;
}

Get-ChildItem -Path $sourcePath -Include "*" | ForEach-Object {
    if($i -eq 0){
        Write-Output " I: Attempting to move $filespersend files";
    }

    Write-Progress -Id 0  "Currently at $i / $filespersend files moved";
    Move-Item -Path $_.FullName -Destination $destPath;
    $i++;

    if ($i -eq $filespersend){
        Write-Output " I: Completed moving $i files";
        Write-Output " I: Waiting $sec_wait seconds before moving on"
        Start-Sleep($sec_wait);
        $cnf = Cnt-Fles($destPath, $ext, 0);
        if($cnf -eq 1){
            $i = 0 ;
        }
        
    }
}