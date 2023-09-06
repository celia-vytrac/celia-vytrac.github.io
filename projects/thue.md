# interpreter for esoteric language Thue

## thue.sh

```bash
#!/bin/bash

set -e

usage="Usage: thue.sh [-h] [-t] -f <FILE>"

CAN_BE="::="
INPUT_STREAM=":::"
OUTPUT_STREAM="~"
TRACE=0

main() {
  while getopts ":htf:" opt; do
    case "$opt" in
      h)
        echo "$usage"
        exit 0
        ;;
      t)
        TRACE=1
        ;;
      f)
        [[ ! -f $OPTARG ]] && echo "$OPTARG: File does not exist" && exit 1
        file="$OPTARG"
        ;;
      \?)
        echo "Invalid option: -$OPTARG" 1>&2
        exit 1
        ;;
      :)
        echo "Invalid option: -$OPTARG requires an argument" 1>&2
        exit 1
        ;;
    esac
  done
  [[ ! $file ]] && echo "Option -f is required" && exit 1
  interpret "$file"
}

interpret() {
  (($# == 1)) || echo "Incorrect number of arguments" || exit 1
  mapfile -t rules < <(sed '/^$/d' "$1" | sed -n "/^$CAN_BE/q;p")
  current=("${rules[@]}")
  statement="$(sed '/^$/d' "$1" | sed -e "1,/^$CAN_BE/d")"
  while ((${#current[@]})); do
    ((!TRACE)) || echo "$statement"
    index="$((RANDOM % ${#current[@]}))"
    lhs="${current[$index]%%$CAN_BE*}"
    rhs="${current[$index]##*$CAN_BE}"
    if [[ $statement == *"$lhs"* && -n $lhs ]]; then
      if [[ ${rhs::1} == "$OUTPUT_STREAM" ]]; then
        echo "${rhs:1}"
        statement="${statement#$lhs}"
      elif [[ $rhs == "$INPUT_STREAM" ]]; then
        read -p "> " input
        statement="${statement/$lhs/$input}"
      else
        statement="${statement/$lhs/$rhs}"
      fi
      current=("${rules[@]}")
    else
      unset 'current[index]'
      current=("${current[@]}")
    fi
  done
  [[ -z $statement ]] || echo "$statement"
}

main "$@"
```
