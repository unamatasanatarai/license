#!/usr/bin/env bash

index_file="metadata/index.txt"
license_dir="licenses"

if [ ! -f "$index_file" ]; then
    printf '%s\n' "missing index file: ${index_file}" >&2
    exit 1
fi

if [ ! -d "$license_dir" ]; then
    printf '%s\n' "missing license directory: ${license_dir}" >&2
    exit 1
fi

status=0
line_number=0

declare -A seen

while IFS= read -r license_name || [ -n "$license_name" ]; do
    line_number=$((line_number + 1))

    [ -n "$license_name" ] || continue

    if [[ ! "$license_name" =~ ^[A-Za-z0-9._+-]+$ ]]; then
        printf '%s\n' \
            "invalid license identifier at line ${line_number}: ${license_name}" >&2

        status=1
        continue
    fi

    case "$license_name" in
    .* | */* | *\\* | *..*)
        printf '%s\n' \
            "unsafe license identifier at line ${line_number}: ${license_name}" >&2

        status=1
        continue
        ;;
    esac

    if [ "${seen[$license_name]+x}" = "x" ]; then
        printf '%s\n' \
            "duplicate license identifier at line ${line_number}: ${license_name}" >&2

        status=1
        continue
    fi

    seen["$license_name"]=1

    if [ ! -f "${license_dir}/${license_name}" ]; then
        printf '%s\n' \
            "missing license file: ${license_dir}/${license_name}" >&2

        status=1
    fi

done <"$index_file"

if [ "$status" -ne 0 ]; then
    exit "$status"
fi

printf '%s\n' 'validation successful'
exit 0
