Function Remove-Completed($steps){
    $completed = ($steps.Keys | %{ $steps[$_] | Select * } | ? Completed).Name
    $steps.Keys | %{
        $name = $_
        $completed | %{ $steps[$name].Required.Remove($_) }
        $steps[$_].RequiredLength = $steps[$_].Required.Count
        }
    Return $steps
}

Function Increment-Work($workers, $letter){
    
    $workers[$smallest] = $seconds + $workers[$smallest]
    $workers
}

$input = gc .\day7_test.txt
$workers = 0,0,0,0,0

$steps = @{}

$step_object = @{
    Required = [System.Collections.ArrayList]@()
    Completed = $false
    Name = ""
    RequiredLength = 0
    RemainingSeconds = 50000
}

$input | %{
    $line = $_.Split(" ")
    $step = $line[7]
    $required = $line[1]

    if($steps.ContainsKey($step) -eq $false){
        $steps.Add($step, (New-Object psobject -Property $step_object)) > $null
        $steps[$step].Required = New-Object System.Collections.ArrayList
        $steps[$step].Name = $step
        if($steps[$step].Required.Contains($required) -eq $false){
            $steps[$step].Required.Add($required) > $null
        }
        $steps[$step].RequiredLength = $steps[$step].Required.Count
    }
    if($steps.ContainsKey($step)){
        if($steps[$step].Required.Contains($required) -eq $false){
            $steps[$step].Required.Add($required) > $null
        }
        $steps[$step].RequiredLength = $steps[$step].Required.Count
    }
    if($steps.ContainsKey($required) -eq $false){
        $steps.Add($required, (New-Object psobject -Property $step_object)) > $null
        $steps[$required].Required = New-Object System.Collections.ArrayList
        $steps[$required].Name = $required
    }
}

$workers = 0,0,0,0,0
$total_seconds = 0

While(($steps.Keys | %{ $steps[$_] | ? Completed -eq $false } | Measure).Count -gt 0){
    $steps.Keys | %{ $steps[$_] | Select * } | ? Completed -eq $false | ? RequiredLength -eq 0 | %{
        $_.Name
    } | Sort | Select -First 1 | %{
        # $workers = Increment-Work($workers, $_)
        Write-Host $_ -NoNewline
        $steps[$_].Completed = $true
        }
    # purge required steps
    $steps = Remove-Completed($steps)
}


# part 2

Write-Host ""

$steps = @{}

$input | %{
    $line = $_.Split(" ")
    $step = $line[7]
    $required = $line[1]

    if($steps.ContainsKey($step) -eq $false){
        $steps.Add($step, (New-Object psobject -Property $step_object)) > $null
        $steps[$step].Required = New-Object System.Collections.ArrayList
        $steps[$step].Name = $step
        if($steps[$step].Required.Contains($required) -eq $false){
            $steps[$step].Required.Add($required) > $null
        }
        $steps[$step].RequiredLength = $steps[$step].Required.Count
    }
    if($steps.ContainsKey($step)){
        if($steps[$step].Required.Contains($required) -eq $false){
            $steps[$step].Required.Add($required) > $null
        }
        $steps[$step].RequiredLength = $steps[$step].Required.Count
    }
    if($steps.ContainsKey($required) -eq $false){
        $steps.Add($required, (New-Object psobject -Property $step_object)) > $null
        $steps[$required].Required = New-Object System.Collections.ArrayList
        $steps[$required].Name = $required
    }
}

$available_workers = 5
$alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
While(($steps.Keys | %{ $steps[$_] | ? Completed -eq $false } | Measure).Count -gt 0){
    $steps.Keys | %{ $steps[$_] | Select * } | ? Completed -eq $false | ? RemainingSeconds -gt 150 | ? RequiredLength -eq 0 | %{
        $_.Name
    } | Sort | Select -First $available_workers | %{
        Write-Host $_ -NoNewline
        $steps[$_].RemainingSeconds = $alphabet.IndexOf($_) + 1 #61
        $available_workers -= 1
        }
    # purge required steps
    $sub = ($steps.Keys | %{ $steps[$_] | Select * } | ? Completed | measure).Count
    $to_be_purged = ($steps.Keys | %{ $steps[$_] | Select * } | ? RemainingSeconds -le 0 | ? Completed -eq $false | measure).Count
    while($to_be_purged -lt 1){
        $steps.Keys | %{ $steps[$_] | Select * } | ? RemainingSeconds -gt 0 | ? RemainingSeconds -lt 150 | ? Completed -eq $false | %{
            $steps[$_.Name].RemainingSeconds -= 1
        }
        $to_be_purged = ($steps.Keys | %{ $steps[$_] | Select * } | ? RemainingSeconds -le 0 | measure).Count
    }
    $steps.Keys | %{ $steps[$_] | Select * } | ? RemainingSeconds -le 0 | ? Completed -eq $false | %{
        $steps[$_.Name].Completed = $true
    }
    $sub = ($steps.Keys | %{ $steps[$_] | Select * } | ? Completed | measure).Count
    $steps = Remove-Completed($steps)
    $available_workers += $sub

    Write-Host "Free Workers: $available_workers"
    $steps.Keys | %{
        Write-Host "Seconds Remaining: "$steps[$_].SecondsRemaining
        Write-Host "Name: "$steps[$_].Name
        Write-Host "Required Length: "$steps[$_].RequiredLength
        "-----------------------------"
    }
    sleep 5
    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
}