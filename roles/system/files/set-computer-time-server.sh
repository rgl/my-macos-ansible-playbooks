#!/bin/bash
set -euxo pipefail

changed='no'

# set the network time server.
# e.g. Network Time Server: time.euro.apple.com
actual_state="$(systemsetup -getnetworktimeserver | perl -ne '/^Network Time Server:\s*(.+)/ && print $1')"
if [ "$actual_state" != "$ARG_COMPUTER_TIME_SERVER" ]; then
    changed='yes'
    systemsetup -setnetworktimeserver "$ARG_COMPUTER_TIME_SERVER"
fi

# enable the network time synchronization.
# e.g. Network Time: On
actual_state="$(systemsetup -getusingnetworktime | perl -ne '/^Network Time:\s*(.+)/ && print $1')"
if [ "$actual_state" != "On" ]; then
    changed='yes'
    systemsetup -setusingnetworktime On
fi

# bail when nothing has changed.
if [ "$changed" == 'no' ]; then
    echo 'ANSIBLE CHANGED NO'
    exit 0
fi

# synchronize the time now.
sntp -sS "$ARG_COMPUTER_TIME_SERVER"
