# create 1000x1000 array
$fabric_squares = New-Object System.Collections.ArrayList
For($x=0; $x -lt 1000; $x++){ $fabric_squares.Add(@(0) * 1000) > $null }

# increment counters on 2d array
$input = gc .\day3_input.txt
$input | %{
    # parse the line
    $line = $_.ToString()
    $coordinates = $line.Split(' ')[2]
    $x = [int]($coordinates.Split(",")[0])
    $y = [int]($coordinates.Split(",")[1].Split(":")[0])
    $dimensions = $line.Split(' ')[3]
    $x_dim = [int]($dimensions.Split("x")[0])
    $y_dim = [int]($dimensions.Split("x")[1])
    
    # update objects
    $_ | Add-Member -MemberType NoteProperty -Name "XCoordinate" -Value $x
    $_ | Add-Member -MemberType NoteProperty -Name "YCoordinate" -Value $y
    $_ | Add-Member -MemberType NoteProperty -Name "XDimension" -Value $x_dim
    $_ | Add-Member -MemberType NoteProperty -Name "YDimension" -Value $y_dim
    $_ | Add-Member -MemberType NoteProperty -Name "Area" -Value ($x_dim * $y_dim)
    

    # find starting coordinates, and increment counters on all affected areas
    #$b = Get-Date
    while($y_dim -gt 0){
        $y_update = $y+$y_dim-1
        $x_dim_copy = $x_dim
        while($x_dim_copy -gt 0){
            $x_update = $x+$x_dim_copy-1
            # increment counter
            $fabric_squares[$x_update][$y_update]+=1
            $x_dim_copy-=1
        }
        $y_dim-=1
    }
    #((Get-Date) - $b).TotalMilliseconds
}

# count square inches with more than one claim
$total = 0
For($x = 0; $x -lt 1000; $x++){
    For($y = 0; $y -lt 1000; $y++){
        if($fabric_squares[$x][$y] -gt 1){ $total+=1 }
    }
}
# part 1
Write-Host "Day 3 Part A: $total"

# part 2
# 2d array is already built, see if any coordinates only have one claim
$input | %{
    # parse the line
    $coordinates = $_.ToString().Split(' ')[2]
    $x = [int]($coordinates.Split(",")[0])
    $y = [int]($coordinates.Split(",")[1].Split(":")[0])
    $dimensions = $_.ToString().Split(' ')[3]
    $x_dim = [int]($dimensions.Split("x")[0])
    $y_dim = [int]($dimensions.Split("x")[1])

    $no_overlap = $true

    while($y_dim -gt 0){
        $y_update = $y+$y_dim-1
        $x_dim_copy = $x_dim
        while($x_dim_copy -gt 0){
            $x_update = $x+$x_dim_copy-1
            $value = $fabric_squares[$x_update][$y_update]
            # more than one claim, move on to next
            if($value -gt 1){
                $no_overlap = $false
                break
            }
            $x_dim_copy-=1
        }
        $y_dim-=1
        if($no_overlap -eq $false){ break }
    }
    if($no_overlap){ Write-Host "Day 3 Part B: $_" }
}