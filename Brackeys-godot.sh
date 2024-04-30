#!/bin/sh
echo -ne '\033c\033]0;Brackeys-godot\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Brackeys-godot.x86_64" "$@"
