#!/bin/bash
set -euo pipefail

export PATH="$PATH:/usr/local/bin:/opt/homebrew/bin"

# verify and bail when its already at the desired state.
# example output:
#   InfluxDB analytics are enabled.
#   Google Analytics were destroyed.
actual_state="$(brew analytics | perl -ne '/(enabled)/ && print $1')"
if [ -z "$actual_state" ]; then
    echo 'ANSIBLE CHANGED NO'
    exit 0
fi

# set the desired state.
brew analytics off
