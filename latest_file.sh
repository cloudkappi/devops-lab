#!/bin/bash

# Variables
REPO_URL="https://artifactory.yourdomain.com/artifactory/your-repo-name/path-to-directory"
AUTH="your_username:your_password"
FILE_PATTERN="your-file-*.ext"  # Replace with your file pattern (e.g., "your-file-*.jar")

# Fetch file list (using curl to get JSON response from Artifactory API)
wget --user=$AUTH --password=$AUTH --output-document=file_list.html "$REPO_URL"

# Parse out file names and modification times from the HTML
FILES=$(grep -Eo 'href="[^"]+' file_list.html | grep -Eo '[^"]+$')

# Extract file names matching the pattern (customize according to the naming convention)
LATEST_FILE=""
LATEST_DATE=0

for FILE in $FILES; do
    if [[ $FILE =~ $FILE_PATTERN ]]; then
        # Extract version and date from file name (assuming filename includes version like your-file-1.0.0-20230920.ext)
        VERSION=$(echo $FILE | grep -oP '\d+\.\d+\.\d+')
        DATE=$(echo $FILE | grep -oP '\d{8}' | xargs -I {} date -d {} +%s)

        # Compare dates to find the latest file
        if [[ $DATE -gt $LATEST_DATE ]]; then
            LATEST_DATE=$DATE
            LATEST_FILE=$FILE
        fi
    fi
done

# Download the latest file using wget
if [[ -n $LATEST_FILE ]]; then
    echo "Downloading latest file: $LATEST_FILE"
    wget --user=$AUTH --password=$AUTH "$REPO_URL/$LATEST_FILE"
else
    echo "No matching files found."
fi
