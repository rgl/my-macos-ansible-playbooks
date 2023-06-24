#!/bin/bash
set -euo pipefail

ARG_BROWSER="$1"

# verify and bail when its already at the desired state.
# example defbro output:
#     org.mozilla.firefox (Firefox)
#   * com.apple.Safari (Safari)
actual_state="$(/usr/local/bin/defbro | perl -ne '/^\* (.+) / && print $1')"
if [ "$actual_state" == "$ARG_BROWSER" ]; then
    echo 'ANSIBLE CHANGED NO'
    exit 0
fi

# set the desired state.
# see https://www.felixparadis.com/posts/how-to-set-the-default-browser-from-the-command-line-on-a-mac/#automatically-accept-the-prompt-with-applescript
osascript - "$ARG_BROWSER" <<'EOF'
on run argv
    do shell script "/usr/local/bin/defbro " & item 1 of argv
    try
        tell application "System Events"
            tell application process "CoreServicesUIAgent"
                tell window 1
                    tell (first button whose name starts with "use")
                        perform action "AXPress"
                    end tell
                end tell
            end tell
        end tell
    end try
end run
EOF
