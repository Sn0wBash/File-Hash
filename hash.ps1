# Script for generating and comparing file hashes.
# Log file will be written to c:\Temp\Log\File-Hash<yy-MM-dd_HH-mm-ss>.txt
# Get-Filehash cmdlet supports the MACTripleDES Algorithm, but I have not included it as an option. It doesn't seem appropriate for the tool.
# To Do :
# Improve log formatting


# Main landing menu
function MainMenu () {
    Clear
    Write-Output "Script for checking file Hashes.`n"
    Write-Output "Log file can be found in C:\Temp\Log\.`n"
    Write-Output "1: Generate a hash."
    Write-Output "2: Generate a hash and compare it with one you already have."
    Write-Output "3: Generate 2 hashes and compare them."
    Write-Output "4: Compare 2 hashes."
    Write-Output "5: Exit.`n"
    $MainMenuInput = Read-Host "Please select an option"
    
    if ($MainMenuInput -eq "1") {
        Menu1
    } elseif ($MainMenuInput -eq "2") {
        Menu2
    } elseif ($MainMenuInput -eq "3") {
        Menu3
    } elseif ($MainMenuInput -eq "4") {
        Menu4
    } elseif ($MainMenuInput -eq "5") {
        Break
    } else {
        Clear
        Write-Output ($MainMenuInput + " is not a valid option") 
        Read-Host "`nPress return to continue"
        MainMenu
    }
}


# Create a hash
function Menu1 () {
    clear
    Write-Log "Generate a hash from a file"
    HashAlgorithm
    Write-Output "`nPlease enter the file path and name. (i.e. c:\temp\test.txt or \\server\folder\file.nfo)`n"
    $FilePath = Read-Host
    Write-Output $FilePath | Out-File -FilePath $path -Append

    try {
        $Time = measure-command { $FirstHash = Get-FileHash -Path $FilePath -Algorithm $Script:HashAlgorithm }
        if ($null -eq $FirstHash) {
            throw
        }

        Write-Output ("`nThe " + $Script:HashAlgorithm + " hash for " + $FilePath + " is:`n")
        Write-Log (($FirstHash).hash + "`n")
        $TimeOut = "The hash took " + $Time.TotalSeconds + " seconds to complete"
        Write-Log $TimeOut
        Read-Host "Press return to continue"
        Write-Output $FormatBreak | Out-File -FilePath $Path -Append
        MainMenu

    } catch {
        Write-Log "`nError. Unable to create hash. Check the file path and name"
        Read-Host "`nPress return to continue"
        MainMenu
    }
}


# Generate a hash and compare it to a hash that is already known
function Menu2 () {
    Clear
    Write-Log "Generate a hash from a file and compare it to a provided hash.`n"
    HashAlgorithm
    Write-Output "`nPlease enter the file path and name. (i.e. c:\temp\test.txt or \\server\folder\file.nfo)`n"
    $FilePath = Read-Host
    Write-Output $FilePath | Out-File -FilePath $path -Append

    try {
        $Time = measure-command { $FirstHash = Get-FileHash -Path $FilePath -Algorithm $Script:HashAlgorithm }
        if ($null -eq $FirstHash) {
            throw
        }
        
        Write-Output ("`nThe " + $Script:HashAlgorithm + " hash for " + $FilePath + " is:`n")
        Write-Output (($FirstHash).hash + "`n")
        $TimeOut = "The hash took " + $Time.TotalSeconds + " seconds to complete"
        Write-Log $TimeOut
        Write-Output "`nPaste the hash you want to check against:`n"
        $SecondHash = Read-Host 
        Check-Match ($FirstHash).hash $SecondHash   
    
    } catch {
        Write-Log "`nError. Unable to create hash. Check the file path and name"
        Read-Host "`nPress return to continue"
        MainMenu
    }
}


# Generate 2 hashes and compare them
function Menu3 () {
    Clear
    Write-Log "Generate a hash from two files and compare them.`n"
    HashAlgorithm
    Write-Output "`nPlease enter the first file path and name. (i.e. c:\temp\test.txt or \\server\folder\file.nfo)`n"
    $FilePath = Read-Host
    Write-Output $FilePath | Out-File -FilePath $path -Append
     
    try {
        $Time = measure-command { $FirstHash = Get-FileHash -Path $FilePath -Algorithm $Script:HashAlgorithm }
          
        if ($null -eq $FirstHash) {
           throw
        }
            
        Write-Output ("`nThe " + $Script:HashAlgorithm + " hash for " + $FilePath + " is:`n")
        Write-Output (($FirstHash).hash + "`n")
        $TimeOut = "The hash took " + $Time.TotalSeconds + " seconds to complete"
        Write-Log $TimeOut
        Write-Output "`nPlease enter the second file path and name. (i.e. c:\temp\test.txt or \\server\folder\file.nfo)`n"
        $FilePath = Read-Host
        Write-Output $FilePath | Out-File -FilePath $path -Append
       
        $Time = measure-command { $SecondHash = Get-FileHash -Path $FilePath -Algorithm $Script:HashAlgorithm }

        if ($null -eq $SecondHash) {
            throw
        }
            
        Write-Output ("`nThe " + $Script:HashAlgorithm + " hash for " + $FilePath + " is:`n")
        Write-Output (($SecondHash).hash + "`n")
        $TimeOut = "The hash took " + $Time.TotalSeconds + " seconds to complete"
        Write-Log $TimeOut
        Check-Match ($FirstHash).hash ($SecondHash).hash

    } catch {
        Write-Log "`nError. Unable to create hash. Check the file path and name"
        Read-Host "`nPress return to continue"
        MainMenu
    }
}


# Determining the Hashing algorithm
function HashAlgorithm () {
    Write-Output "Hash algorithm.`n"
    Write-Output "1: SHA1 (Not Recommended)"
    Write-Output "2: SHA256" 
    Write-Output "3: SHA384"
    Write-output "4: SHA512"
    Write-Output "5: MD5 (Not Recommended)"
    Write-Output "6: RIPEMD160"
    $HashAlgorithmInput = Read-Host "`nPlease select an option"
    
    if ($HashAlgorithmInput -eq "1") {
        $Script:HashAlgorithm = "SHA1"
    } elseif ($HashAlgorithmInput -eq "2") {
        $Script:HashAlgorithm = "SHA256"
    } elseif ($HashAlgorithmInput -eq "3") {
        $Script:HashAlgorithm = "SHA348"
    } elseif ($HashAlgorithmInput -eq "4") {
        $Script:HashAlgorithm = "SHA512"
    } elseif ($HashAlgorithmInput -eq "5") {
        $Script:HashAlgorithm = "MD5"
    } elseif ($HashAlgorithmInput -eq "6") {
        $Script:HashAlgorithm = "RIPEMD160"
    } else {
        Write-Output ("`n" + $HashAlgorithmInput + " is not a valid option.") 
        Read-Host "`nPress return to continue"
        HashAlgorithm
    }
    Write-Output $Script:HashAlgorithm | Out-File -FilePath $Path -Append
}


# Compare 2 strings
function Menu4 () {
    Clear
    Write-Log "Will compare if two strings match.`n"
    $FirstHash = Read-Host "Paste your first hash"
    $SecondHash = Read-Host "Paste your second hash"
    Check-Match $FirstHash $SecondHash 
}


# Evaluate if 2 arguments match
function Check-Match ($Arg1, $Arg2) {
    clear
    $Arg3 = $Arg1 + "`n" + $Arg2
    Write-Log $Arg3
    if ($Arg1 -eq $Arg2) {
        Write-Log "`nThe hash matches!`n"
       
    } else {
        Write-Log "`nThe hash doesn't match!`n"
    }
    
    Read-Host "Press return to continue"
    Write-Output $FormatBreak | Out-File -FilePath $Path -Append
    MainMenu
}


# Write output to terminal and to the log file 
function Write-Log ($Arg4) {
    Write-Output $Arg4
    Write-Output $Arg4 | Out-File -FilePath $Path -Append
}


#Check if path to log file exists and if not create it
If (Test-Path -Path C:\Temp\Log) {
    # Do nothing
} Else {
    New-Item -ItemType Directory -Path C:\Temp\Log
}

# Format the log path and filename
$StartDate = Get-Date -Format "yy-MM-dd_HH-mm-ss"
$FileName = "File-Hash_" + $StartDate + ".txt"
$Path = "c:\Temp\Log\" + $FileName
$FormatBreak = "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n"

# Start the menu system
MainMenu
