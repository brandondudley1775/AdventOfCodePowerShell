# part 1, group letters and find instances where there are 2 and 3 occurrences of the same character
$two_count = 0
$three_count = 0
gc .\day2_input.txt | %{
    # see if there are letters that appear twice or three times
    $two = ($_.ToString().ToCharArray() | Group-Object | ? count -EQ 2 | measure).count
    $three = ($_.ToString().ToCharArray() | Group-Object | ? count -EQ 3 | measure).count
    # increment counts
    if($two -gt 0){ $two_count+=1 }
    if($three -gt 0){ $three_count+=1 }
}
# multiply results for checksum
$result = $two_count * $three_count
Write-Host "Day 2 Part A: $result"

# use hash lookup table
$fast_values = @{}
$start = 1
# see how long ids are
$len = (gc .\day2_input.txt)[0].ToString().Length
Write-Host "Day 2 Part B: " -NoNewline
# iterate through ids, removing one letter per iteration and grouping to look for duplicates
while($start -lt $len){
    (gc .\day2_input.txt | %{
        $_.ToString().Substring(0,$start)+$_.ToString().Substring($start+1,$len-($start+1))
    } | Group-Object | ? Count -gt 1).Name
    $start+=1
}