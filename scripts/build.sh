#!/bin/bash

main () {
    [[ -z "$1" ]] && error "Usage: ${0##*/} <DIRECTORY>"
    BUILD_DIR="$1"
    "$GITHUB_WORKSPACE/scripts/ssg5" "$GITHUB_WORKSPACE" "$BUILD_DIR" 'web.vytrac.me'
    find "$GITHUB_WORKSPACE" -name '*.md' -exec "$GITHUB_WORKSPACE/scripts/publish.sh" {} "$BUILD_DIR" \;
}

error() {
    echo "$1"
    exit 1
}

main "$@"
