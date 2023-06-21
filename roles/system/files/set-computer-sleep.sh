#!/bin/bash
set -euxo pipefail

# verify and bail when its already in the desired state.
# e.g. Computer Sleep: Never
# e.g. Computer Sleep: after 180 minutes
actual_state="$(systemsetup -getcomputersleep | perl -ne '/^Computer Sleep:.+?(Never|\d+)/ && print $1')"
if [ "$actual_state" == "$ARG_COMPUTER_SLEEP" ]; then
    echo 'ANSIBLE CHANGED NO'
    exit 0
fi

# set the desired state.
systemsetup -setcomputersleep "$ARG_COMPUTER_SLEEP"
