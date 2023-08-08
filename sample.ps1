# Specify the path to your input file containing usernames
$filePath = "C:\path\to\usernames.txt"

# Specify the base URL for the REST API
$baseUrl = "https://api.example.com/status"

# Read the file line by line and process each username
Get-Content -Path $filePath | ForEach-Object {
    $username = $_
    $url = "$baseUrl?username=$username"
    Write-Host "Checking status for username: $username"

    try {
        $response = Invoke-RestMethod -Uri $url -Method Get -ContentType "application/json"
        # Process the response here if needed
        Write-Host "Response for $username: $($response | ConvertTo-Json -Depth 4)"
    } catch {
        Write-Host "Error checking status for $username: $($_.Exception.Message)"
    }
}
