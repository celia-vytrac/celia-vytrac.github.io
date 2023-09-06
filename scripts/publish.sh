#!/bin/bash

main () {

    [[ -z "$1" ]] && usage "Usage: ${0##*/} <FILE.md> <DIRECTORY>"
    [[ -z "$2" ]] && usage "Usage: ${0##*/} <FILE.md> <DIRECTORY>"

    echo "Working with file: $1"
    # change the extension to html
    FNAME="${1::-2}html"
    FNAME=${FNAME//$GITHUB_WORKSPACE/}
    echo "Truncated name: $FNAME"
    # generate rss item and set guid
    REGEX="s|<guid.*uid>|<guid>web.vytrac.me$FNAME</guid>|"
    TEMP=$(mktemp)
    "$GITHUB_WORKSPACE/scripts/rssg" "$1" | sed -e "$REGEX" > "$TEMP"
    # separate rss headings from item body
    TEMP_DIR=$(mktemp -d)
    csplit "$2/rss.xml" 8 -f "$TEMP_DIR/xx"
    echo "$TEMP"
    # put the pieces back together with the new item
    cat "$TEMP_DIR/xx00" "$TEMP" "$TEMP_DIR/xx01" > "$2/rss.xml"
    # update LastBuildDate
    REGEX="s|<last.*Date>|<lastBuildDate>$(date -R)</lastBuildDate>|"
    sed -i -e "$REGEX" "$2/rss.xml"
    rm -r "$TEMP" "$TEMP_DIR"
}

error() {
    echo "$1"
    exit 1
}

main "$@"
