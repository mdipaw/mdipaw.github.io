#!/bin/bash

read_json() {
  local file="$1"
  cat "$file" | jq -c . # Use jq to parse JSON and keep compact format
}

display="$1"
control="$2"
screenshots="$3"

# Read the content of each JSON file
display_json=$(read_json "$display")
control_json=$(read_json "$control")
screenshots_json=$(read_json "$screenshots")

# Extract relevant fields from control_json
pkg_name=$(echo "$control_json" | jq -r '.Name')
version=$(echo "$control_json" | jq -r '.Version')
description=$(echo "$control_json" | jq -r '.Description')
maintainer=$(echo "$control_json" | jq -r '.Maintainer')
author=$(echo "$control_json" | jq -r '.Author')
section=$(echo "$control_json" | jq -r '.Section')
depends=$(echo "$control_json" | jq -r '.Depends')

# Extract changelog from display_json
changelog=$(echo "$display_json" | jq '.changelog')

# Extract screenshots from screenshots_json
screenshots=$(echo "$screenshots_json" | jq '.screenshots')

# Create the output JSON structure
output_json=$(
  jq -n \
    --arg pkg_name "$pkg_name" \
    --arg version "$version" \
    --arg description "$description" \
    --arg maintainer "$maintainer" \
    --arg author "$author" \
    --arg section "$section" \
    --arg depends "$depends" \
    --argjson changelog "$changelog" \
    --argjson screenshots "$screenshots" \
    '
  {
  "minVersion": "0.4",
  "headerImage": "https://mdipaw.github.io/repo/CydiaIcon.png",
  "tintColor": "#47afd1",
  "class": "DepictionTabView",
  "tabs": [
    {
      "tabname": "Details",
      "class": "DepictionStackView",
      "views": [
        {
          "title": "$pkg_name",
          "useBoldText": true,
          "useBottomMargin": false,
          "class": "DepictionSubheaderView"
        },
        {
          "itemCornerRadius": 6,
          "itemSize": "{160, 275.41333333333336}",
          "screenshots": [
            {
              "accessibilityText": "Screenshot",
              "url": "https://mdipaw.github.io/repo/CydiaIcon.png",
              "fullSizeURL": "https://mdipaw.github.io/repo/CydiaIcon.png"
            }
          ],
          "class": "DepictionScreenshotsView"
        },
        {
          "markdown": "$description",
          "useSpacing": true,
          "class": "DepictionMarkdownView"
        },
        {
          "class": "DepictionSeparatorView"
        },
        {
          "title": "Latest Version",
          "class": "DepictionHeaderView"
        },
        {
          "title": "Version",
          "text": "$version",
          "class": "DepictionTableTextView"
        },
        {
          "title": "Released",
          "text": "$changelog",
          "class": "DepictionTableTextView"
        },
        {
          "title": "Developer",
          "text": "$author",
          "class": "DepictionTableTextView"
        },
        {
          "title": "Contact Support",
          "action": "mailto:dhifa.aghisni@gmail.com",
          "class": "DepictionTableButtonView"
        },
        {
          "spacing": 16,
          "class": "DepictionSpacerView"
        },
        {
          "spacing": 20,
          "class": "DepictionSpacerView"
        }
      ]
    }
  ]
}'
)

echo "$output_json"
