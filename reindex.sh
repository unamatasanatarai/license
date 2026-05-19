#!/usr/bin/env bash

__index_file="metadata/index.txt"
__license_dir="licenses-templates"

[[ -d "$__license_dir" ]] || {
	printf 'error: directory not found: %s\n' "$__license_dir" >&2
	exit 1
}

[[ -d "metadata" ]] || mkdir -p "metadata"

shopt -s nullglob

for __f in "$__license_dir"/*; do
	[[ -f "$__f" ]] || continue
	printf '%s\n' "${__f##*/}"
done >"$__index_file"
