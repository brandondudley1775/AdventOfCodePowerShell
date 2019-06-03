$input = (gc .\day5_input.txt).ToString()
$input_copy = $input

$shortest = $input.Length

$input_len = $input.Length

$alphabet = "abcdefghijklmnopqrstuvwxyz"
While(1){
    for($i=0; $i -lt $alphabet.Length; $i++){
        $upper_first = $alphabet[$i].ToString().ToUpper()+$alphabet[$i]
        $lower_first = $alphabet[$i]+$alphabet[$i].ToString().ToUpper()
        $input_copy = $input_copy.Replace($upper_first, "")
        $input_copy = $input_copy.Replace($lower_first, "")
    }
    if($input_len -eq $input_copy.Length){ break }
    $input_len = $input_copy.Length
}
Write-Host "Day 5 Part A: " -NoNewline
$input_len

for($j=0; $j -lt $alphabet.Length; $j++){
    $input_copy = $input

    $input_copy = $input.Replace($alphabet[$j].ToString(), '')
    $input_copy = $input.Replace($alphabet[$j].ToString().ToUpper(), '')

    $input_len = $input_copy.Length

    $alphabet = "abcdefghijklmnopqrstuvwxyz"
    $running = $true
    While($running){
        for($i=0; $i -lt $alphabet.Length; $i++){
            $upper_first = $alphabet[$i].ToString().ToUpper()+$alphabet[$i]
            $lower_first = $alphabet[$i]+$alphabet[$i].ToString().ToUpper()
            $input_copy = $input_copy.Replace($upper_first, "")
            $input_copy = $input_copy.Replace($lower_first, "")
        }
        if($input_len -eq $input_copy.Length){ $running = $false }
        else{ $input_len = $input_copy.Length }
    }
    if($shortest -gt $input_len){ $shortest = $input_len }
}
Write-Host "Day 5 Part B: " -NoNewline
$shortest