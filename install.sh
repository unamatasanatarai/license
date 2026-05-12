#!/usr/bin/env bash

install_dir="${XDG_BIN_HOME:-${HOME}/.local/bin}"
target="${install_dir}/license"

script_url="https://raw.githubusercontent.com/unamatasanatarai/license/master/license"

if ! command -v curl >/dev/null 2>&1; then
    printf '%s\n' 'curl is required' >&2
    exit 1
fi

mkdir -p "$install_dir"

status="$?"

if [ "$status" -ne 0 ]; then
    printf '%s\n' 'failed to create install directory' >&2
    exit 1
fi

tmp_file="$(mktemp "${TMPDIR:-/tmp}/license-install.$$")"

if [ ! -f "$tmp_file" ]; then
    printf '%s\n' 'failed to create temporary file' >&2
    exit 1
fi

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
    printf '%s\n' 'failed to download installer payload' >&2
    exit 1
fi

if [ ! -s "$tmp_file" ]; then
    rm -f "$tmp_file"
    printf '%s\n' 'downloaded file is empty' >&2
    exit 1
fi

chmod +x "$tmp_file"

status="$?"

if [ "$status" -ne 0 ]; then
    rm -f "$tmp_file"
    printf '%s\n' 'failed to mark executable' >&2
    exit 1
fi

mv "$tmp_file" "$target"

status="$?"

if [ "$status" -ne 0 ]; then
    rm -f "$tmp_file"
    printf '%s\n' 'failed to install binary' >&2
    exit 1
fi

printf '%s\n' "installed: ${target}"

case ":$PATH:" in
*":${install_dir}:"*)
    ;;
*)
    printf '\n%s\n\n' 'add this to your shell profile:'
    printf '%s\n' "export PATH=\"${install_dir}:\$PATH\""
    ;;
esac

printf '\n%s\n' 'usage:'
printf '%s\n' '  license list'
printf '%s\n' '  license download MIT'
printf '%s\n' '  license download Apache-2.0'
