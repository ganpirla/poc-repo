# Specify the path to your input file
$filePath = "C:\path\to\usernames.txt"

# Specify the base URL for checking usernames
$baseUrl = "https://example.com/check_username"

# Read the file line by line and process each username
foreach ($username in Get-Content -Path $filePath) {
    $url = "$baseUrl?username=$username"
    Write-Host "Checking status for username: $username"

    try {
        $response = Invoke-RestMethod -Uri $url
        # Process the response here if needed
        Write-Host "Response for $username: $($response | ConvertTo-Json -Depth 4)"
    } catch {
        Write-Host "Error checking status for $username: $($_.Exception.Message)"
    }
}
