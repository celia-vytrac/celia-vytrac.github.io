#!/bin/bash

main () {

[[ -z "$1" ]] && error "Usage: ${0##*/} <FILE.md>"

# awk translates newlines into literal '\n' character
# sed is used to escape the quotes so it doesn't interfere with json
markdown="$(sed 's/\\/\\\\/g' < "$1" | awk '{printf "%s\\n", $0}' | sed 's/"/\\"/g')"

# prepare the json payload
payload=$(cat <<EOF
{
    "text": "$markdown",
    "mode": "gfm",
    "context" : "github/celia-vytrac"
}
EOF
)

# execute the POST request
curl \
    -H "Content-Type: application/json" \
    -X POST \
    -d "$payload" \
    https://api.github.com/markdown
}

error() {
    echo "$1"
    exit 1
}

main "$@"
