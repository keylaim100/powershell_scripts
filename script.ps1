function Start-ProgressBar {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title,

        [Parameter(Mandatory = $true)]
        [int]$Timer
    )

    for ($i = 1; $i -le $Timer; $i++) {
        Start-Sleep -Seconds 1

        $percent = [int](($i / $Timer) * 100)

        Write-Progress `
            -Activity $Title `
            -Status "Segundo $i de $Timer" `
            -PercentComplete $percent
    }

    Write-Progress -Activity $Title -Status "Completado" -Completed
}

Start-ProgressBar -Title "Test timeout" -Timer 30