#!/usr/bin/env bash

install_dir="${XDG_BIN_HOME:-${HOME}/.local/bin}"
base_url="https://raw.githubusercontent.com/unamatasanatarai/licenses/master"

files=("licenses" "licenses-list" "licenses-get" "licenses-update")

if ! command -v curl >/dev/null 2>&1; then
    printf '%s\n' 'curl is required' >&2
    exit 1
fi

mkdir -p "$install_dir" || {
    printf '%s\n' 'failed to create install directory' >&2
    exit 1
}

for file in "${files[@]}"; do
    target="${install_dir}/${file}"
    script_url="${base_url}/${file}"

    printf 'installing %s...\n' "$file"

    tmp_file="$(mktemp "${TMPDIR:-/tmp}/license-install-${file}.$$")"

    curl \
        --silent \
        --show-error \
        --fail \
        --location \
        --connect-timeout 10 \
        --max-time 30 \
        --output "$tmp_file" \
        "$script_url"

    status="$?"
    if [ "$status" -ne 0 ]; then
        rm -f "$tmp_file"
        printf 'failed to download %s\n' "$file" >&2
        exit 1
    fi

    if [ ! -s "$tmp_file" ]; then
        rm -f "$tmp_file"
        printf '%s\n' "downloaded file ${file} is empty" >&2
        exit 1
    fi

    chmod +x "$tmp_file"
    mv "$tmp_file" "$target"
done

printf '\ninstalled to: %s\n' "$install_dir"

case ":$PATH:" in
*":${install_dir}:"*) ;;
*)
    printf '\n%s\n\n' 'add this to your shell profile:'
    printf '%s\n' "export PATH=\"${install_dir}:\$PATH\""
    ;;
esac

printf '\n%s\n' 'usage:'
printf '%s\n' '  licenses update'
printf '%s\n' '  licenses list'
printf '%s\n' '  licenses get MIT'
