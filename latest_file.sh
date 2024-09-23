#!/bin/bash

# Variables
REPO_URL="https://artifactory.yourdomain.com/artifactory/your-repo-name/path-to-directory"
AUTH="your_username:your_password"

# Fetch the file list from the server (adjust as needed for your server setup)
FILES=$(wget --user=$AUTH --password=$AUTH --no-remove-listing $REPO_URL -O - 2>/dev/null | grep -Eo '[0-9]{5}-jodo-[0-9]{8}\.[0-9]+\.zip')

# Initialize variables to track the latest file
LATEST_FILE=""
LATEST_DATE=0
LATEST_VERSION=0

# Loop through the file list
for FILE in $FILES; do
    # Extract the date (YYYYMMDD) from the filename
    DATE=$(echo $FILE | grep -oP '(?<=-jodo-)[0-9]{8}')
    
    # Extract the version from the filename (e.g., 3 in .3.zip)
    VERSION=$(echo $FILE | grep -oP '(?<=\.)[0-9]+(?=\.zip)')

    # Convert the date to a comparable format (UNIX timestamp for accurate comparison)
    DATE_TIMESTAMP=$(date -d "$DATE" +%s 2>/dev/null)
    
    # Check if the date conversion was successful (i.e., if the format is valid)
    if [[ -z $DATE_TIMESTAMP ]]; then
        echo "Skipping invalid date format in file: $FILE"
        continue
    fi

    # Compare the current file's date and version to the latest found so far
    if [[ $DATE_TIMESTAMP -gt $LATEST_DATE ]] || { [[ $DATE_TIMESTAMP -eq $LATEST_DATE ]] && [[ $VERSION -gt $LATEST_VERSION ]]; }; then
        LATEST_DATE=$DATE_TIMESTAMP
        LATEST_VERSION=$VERSION
        LATEST_FILE=$FILE
    fi
done

# If a latest file is found, download it using wget
if [[ -n $LATEST_FILE ]]; then
    echo "Downloading latest file: $LATEST_FILE"
    wget --user=$AUTH --password=$AUTH "$REPO_URL/$LATEST_FILE" -O "$LATEST_FILE"
else
    echo "No files found."
fi
