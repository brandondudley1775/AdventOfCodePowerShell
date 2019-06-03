# part one, sum the integers
$sum = 0
gc .\day1_input.txt | % { $sum += [int]$_ }
Write-Host "Day 1 Part A: $sum"

# part two, find first value that appears twice
$sum = 0
$fast_values = @{}
$fast_values.Add($sum, $sum)
$nums = gc .\day1_input.txt
while(1){
    $nums | %{
        $sum += [int]$_
        if($fast_values[$sum]){
            Write-Host "Day 1 Part B: $sum"
            exit
        }
        $fast_values.Add($sum, $sum)
    }
}