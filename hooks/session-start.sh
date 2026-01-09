#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Read using-piso18method content
using_skill_content=$(cat "${PLUGIN_ROOT}/skills/using-piso18method/SKILL.md" 2>&1 || echo "Error reading skill")

# Escape for JSON
escape_for_json() {
    local input="$1"
    local output=""
    local i char
    for (( i=0; i<${#input}; i++ )); do
        char="${input:$i:1}"
        case "$char" in
            $'\\') output+='\\';;
            '"') output+='\"';;
            $'\n') output+='\n';;
            $'\r') output+='\r';;
            $'\t') output+='\t';;
            *) output+="$char";;
        esac
    done
    printf '%s' "$output"
}

escaped_content=$(escape_for_json "$using_skill_content")

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "<METHODOLOGY>\nYou have piso18method installed.\n\n**The methodology skill is loaded below. For other skills, use the Skill tool:**\n\n${escaped_content}\n</METHODOLOGY>"
  }
}
EOF

exit 0
