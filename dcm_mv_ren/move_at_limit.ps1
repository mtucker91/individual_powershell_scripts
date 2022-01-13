#   Script Name: Move Files At Limit
#        Author: Matthew Tucker
#  Date Created: 1/11/2022
# Date Modified: 1/12/2022
#   Description: This script moves a certain amount of files from a source directory to a
#                destination directory.  This is done to allow outside programs that would process files
#                in the destination directory time to process them before more files are put in.  The script
#                is also set to only move files when there is nothing in the directory and checks the amount
#                of seconds set by the user.
#                
#       Credits:
#            Author: ctigeek
#            Script: Start-Sleep function provided inside this script
#               URL: https://gist.github.com/ctigeek/bd637eeaeeb71c5b17f4
############################################################
#################### Edit Variables Here ###################
############################################################

# The number of files the script grabs at one time.
$filespersend = 1000;
# Folder where it grabs files from
$sourcePath = "C:\Users\mtuck\Documents\Files\programming\batch\comp_scripts\shell_batch_log\shutdown_logs_old";
# Folder it puts the files in place
$destPath = "C:\Users\mtuck\Documents\Files\programming\batch\comp_scripts\shell_batch_log\shutdown_logs";
# Set however many seconds the script waits before it attempts to confirm if files are still in the destination folder.
$sec_wait = 10;


############################################################
################# End Edit Variables Here ##################
############################################################
$source_cnt = $filespersend + 1;
$i = 0;
$mv = 1;
$cm = 1;

function Start-Sleep($seconds) { # This function is the one provided by ctigeek
    $doneDT = (Get-Date).AddSeconds($seconds)
    while($doneDT -gt (Get-Date)) {
        $secondsLeft = $doneDT.Subtract((Get-Date)).TotalSeconds
        $percent = ($seconds - $secondsLeft) / $seconds * 100
        Write-Progress -Activity "Waiting" -Status "Waiting $seconds seconds before confirming files cleared out..." -SecondsRemaining $secondsLeft -PercentComplete $percent
        [System.Threading.Thread]::Sleep(500)
    }
    Write-Progress -Activity "Sleeping" -Status "Sleeping..." -SecondsRemaining 0 -Completed
}

function Find-Files($dpath){

    # count the amount of files in the destination folder
    $cf = (Get-ChildItem -File -Path $dpath | Measure-Object).Count
    
    if($cf -le 1){ # If the destination folder is pretty much cleared out
        $r = 1 #return the value that the destination folder is cleared out
    }
    else{
        $r = 0 #return the value that the destination folder is not cleared out.
    }

    return $r; #return whatever the resulting value is
}

function Move-Files($fileinfo, $i, $fileps, $destPath){
    Write-Progress -Id 0  "Currently at $i / $fileps files moved";
    Move-Item -Path $fileinfo.FullName -Destination $destPath;
}


do {
    # Pre-file checks
    if($i -eq 0){ # If the amount of files that has yet to move this iteration has not started.
        if($source_cnt -lt $filespersend){ # If the amount of files left is less than the files number to move
            $filespersend = $source_cnt # make the files number to move the same as what is left
        }
        Write-Output " I: Attempting to move $filespersend files"; # output a message stating the script is about to start moving the files
    }

    # Actual Moving Operations
    if($mv -eq 1){ # If the script should be moving files at all
        Get-ChildItem -Path $sourcePath -file | Select-Object -first 1 | Move-Files($_, $i, $filespersend, $destPath);
        $i++; # iterate that it moved a single file
        $source_cnt--; # decrement the total amount of files left
    }

    # Post-file checks (after set amount of files have been moved)
    if ($i -eq $filespersend){ # If the amount of files moved has reached the number of files the user wants to moved at one time.
        $mv = 0; # Turn off the ability to move files again for the time being.
        if($cm -eq 1){ # If 'completing moving' of the files is true (1)
            Write-Output " I: Completed moving $i files";
            $cm = 0; # Set 'completed move' = false for the next iteration
        }
        Start-Sleep($sec_wait); # Wait the user set amount of seconds before attempting the next feat.
        $cnf = Find-Files($destPath); # Check to see if there are any files left to process in the destination folder
        if($cnf -eq 1){ # If 'confirm no files' is true (1)
            $i = 0 ; # set the amount of files sent back to 0
            $mv = 1; # make sure the script can start moving files again
            $cm = 1; # 
            $source_cnt = (Get-ChildItem -File -Path $sourcePath | Measure-Object).Count
        }
    }

} while($source_cnt -gt 0)






# Get-ChildItem -Path $sourcePath -Include "*" | ForEach-Object {
#     #This whole thing is looping each time

#     if($i -eq 0){ # If the amount of files that has yet to move this iteration has not started.
#         if($source_cnt -lt $filespersend){ # If the amount of files left is less than the files number to move
#             $filespersend = $source_cnt # make the files number to move the same as what is left
#         }
#         Write-Output " I: Attempting to move $filespersend files"; # output a message stating the script is about to start moving the files
#     }

#     if($mv -eq 1){ # If the script should be moving files at all
#         Move-Files($_, $i, $filespersend, $destPath); # Go to the function that does the file moving
#         $i++; # iterate that it moved a single file
#         $source_cnt--; # decrement the total amount of files left
#     }
    
#     if ($i -eq $filespersend){ # If the amount of files moved has reached the number of files the user wants to moved at one time.
#         $mv = 0; # Turn off the ability to move files again for the time being.
#         if($cm -eq 1){ # If 'completing moving' of the files is true (1)
#             Write-Output " I: Completed moving $i files";
#             $cm = 0; # Set 'completed move' = false for the next iteration
#         }
#         Start-Sleep($sec_wait); # Wait the user set amount of seconds before attempting the next feat.
#         $cnf = Find-Files($destPath); # Check to see if there are any files left to process in the destination folder
#         if($cnf -eq 1){ # If 'confirm no files' is true (1)
#             $i = 0 ; # set the amount of files sent back to 0
#             $mv = 1; # make sure the script can start moving files again
#             $cm = 1; # 
#         }
        
#     }
# }