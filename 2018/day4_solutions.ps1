$guards = @{}
$current_guard = ""
$start = Get-Date
$duration = 0

# sort the actions, keep tally of which actions happened when
$actions = gc .\day4_inpyt.txt | %{
    $_ | Add-Member -MemberType NoteProperty -Name "TimeStamp" -Value (Get-Date $_.Split("]")[0].Replace("[", ""))
    if($_ -like "*begins shift*"){
        $_ | Add-Member -MemberType NoteProperty -Name "Action" -Value "begin";
        $_ | Add-Member -MemberType NoteProperty -Name "GuardID" -Value ($_.Split(" ")[3].Replace('#', ""))
        }

    if($_ -like "*falls asleep*"){ $_ | Add-Member -MemberType NoteProperty -Name "Action" -Value "sleep" }
    if($_ -like "*wakes up*"){ $_ | Add-Member -MemberType NoteProperty -Name "Action" -Value "wake" }
    
    $_ | Select *
} | sort TimeStamp | %{
    if($_.GuardID){ $current_guard = $_.GuardID }
    if($_.Action -EQ "sleep"){
        $start = $_.TimeStamp
        $_ | Add-Member -MemberType NoteProperty -Name "GuardID" -Value $current_guard
    }
    if($_.Action -EQ "wake"){
        if($guards.ContainsKey($current_guard) -EQ $false){ $guards.Add($current_guard, 0) }
        $guards[$current_guard] += ($_.TimeStamp - $start).TotalMinutes
        $_ | Add-Member -MemberType NoteProperty -Name "GuardID" -Value $current_guard
    }
    $_
} 

$sleep_minutes = @{}
For($i=0; $i -lt 60; $i++){ $sleep_minutes.Add($i, 0) }
# get actions of guard that slept the most
$actions | ? GuardID -EQ ($guards.GetEnumerator() | Sort Value | Select -Last 1).Name | %{
    if($_.Action -EQ "wake" ){
        $duration = [int]($_.TimeStamp - $start).TotalMinutes
        $current_minute = $start.Minute
        While($duration -GT 0){
            $sleep_minutes[$current_minute] += 1
            $current_minute+=1
            $duration-=1
        }
    }
    if($_.Action -EQ "sleep" ){
        $start = $_.TimeStamp
    }
}
Write-Host "Day 4 Part A: " -NoNewline
[int]($sleep_minutes.GetEnumerator() | sort Value | Select -Last 1).Name * [int]($guards.GetEnumerator() | Sort Value | Select -Last 1).Name

$sleepiest_guard = ""
$sg_minutes_asleep = 0
$sleepiest_minute = ""
$guards.Keys | %{
    For($i=0; $i -lt 60; $i++){ $sleep_minutes[$i] = 0 }
    $actions | ? GuardID -EQ $_ | %{
        if($_.Action -EQ "wake" ){
            $duration = [int]($_.TimeStamp - $start).TotalMinutes
            $current_minute = $start.Minute
            While($duration -GT 0){
                $sleep_minutes[$current_minute] += 1
                $current_minute+=1
                $duration-=1
            }
        }
        if($_.Action -EQ "sleep" ){
            $start = $_.TimeStamp
        }
    }
    $tmp = [int]($sleep_minutes.GetEnumerator() | sort Value | Select -Last 1).Value
    if($tmp -gt $sg_minutes_asleep){ $sleepiest_guard = $_; $sg_minutes_asleep = $tmp; $sleepiest_minute = [int]($sleep_minutes.GetEnumerator() | sort Value | Select -Last 1).Name }
}
Write-Host "Day 4 Part B: " -NoNewline
[int]$sleepiest_guard * [int]$sleepiest_minute