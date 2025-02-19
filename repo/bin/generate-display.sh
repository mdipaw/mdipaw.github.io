#!/bin/bash

# Read the input control file
input_file=$1

# Check if the input file exists
if [ ! -f $input_file ]; then
  echo "Input file does not exist!"
  exit 1
fi

# Parse the fields from the control file
version=$(grep -i "^Version:" $input_file | cut -d " " -f 2)
name=$(grep -i "^Name:" $input_file | cut -d " " -f 2-)
description=$(grep -i "^Description:" $input_file | cut -d " " -f 2-)

# Create a JSON object from the parsed fields
# "source_code_link": "https://github.com/mdipaw/$name"
json_object=$(cat << EOF
{
    "contact": {
        "twitter": "mdipaw",
        "email": "mdipawijaya@outlook.com"
    },
    "information": {
        "description": "$description"
    },
    "changelog": [
        {
            "date": "$(date +%Y-%m-%d)",
            "version_number": "$version",
            "changes": "Initial release"
        }
    ]
}
EOF
)

# Print the JSON object to the console
echo $json_object
