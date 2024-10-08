#!/bin/sh
echo -ne '\033c\033]0;KarinRPG\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/karinrpg.x86_64" "$@"
