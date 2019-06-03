Function Stop-Timer($time){
    Write-Host "Completed in " -NoNewline -ForegroundColor Green
    Write-Host ((Get-Date) - $time).TotalSeconds -NoNewline -ForegroundColor Green
    Write-Host " seconds." -ForegroundColor Green
    }

Get-ChildItem day*.ps1 | ForEach{
    Write-Host "Running"$_.Name -ForegroundColor Yellow
    $time = Get-Date
    & $_.FullName
    Stop-Timer($time)
}