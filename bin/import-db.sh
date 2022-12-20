#!/usr/bin/env bash

DATABASE=''

while getopts ":hd:" opt; do
  case $opt in
    d)
      DATABASE="${OPTARG}"
    ;;
    h)
      printf "%s\n" "  Usage: $0 <flags>"
      printf "%s\n" ""
      printf "%s\n" "  Available flags:"
      printf "%s\n" "  -d    Name of the database."
      printf "%s\n" "  -h    This help."
      exit 0;
    ;;

    \?)
      echo "Unknown flag has been used: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

shift "$((OPTIND-1))"

mysql -uroot "${DATABASE}" < /dev/stdin