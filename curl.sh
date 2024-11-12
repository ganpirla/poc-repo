#!/bin/bash

# Define the API endpoint and payload
URL="https://your-api-url.com/endpoint"
PAYLOAD='{"key":"value"}'

# Use curl with timing info
curl -X POST "$URL" \
     -H "Content-Type: application/json" \
     -d "$PAYLOAD" \
     -w "\nTime Summary:\n\
     Time Total:  %{time_total} seconds\n\
     Time Connect: %{time_connect} seconds\n\
     Time Start Transfer: %{time_starttransfer} seconds\n\
     Time Pre-Transfer: %{time_pretransfer} seconds\n\
     Time Redirect: %{time_redirect} seconds\n" \
     -o /dev/null
