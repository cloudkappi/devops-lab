#!/bin/bash

# Variables
REPO_URL="https://artifactory.yourdomain.com/artifactory/your-repo-name/path-to-directory"
AUTH="your_username:your_password"

# Fetch the file list from the server
FILES=$(wget --user=$AUTH --password=$AUTH --no-remove-listing $REPO_URL -O - 2>/dev/null | grep -Eo '[0-9]{5}-jodo-[0-9]{8}\.[0-9]+\.zip')

# Initialize variables to track the latest file
LATEST_FILE=""
LATEST_DATE=0
LATEST_VERSION=0

# Loop through the file list
for FILE in $FILES; do
    # Extract the date and version from the filename
    DATE=$(echo $FILE | grep -oP '(?<=-jodo-)[0-9]{8}')
    VERSION=$(echo $FILE | grep -oP '(?<=\.)([0-9]+)(?=\.zip)')

    # Convert the date to a comparable format (UNIX timestamp)
    DATE_TIMESTAMP=$(date -d "$DATE" +%s)

    # Compare the current file's date and version to the latest found
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
