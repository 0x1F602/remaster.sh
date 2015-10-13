#!/bin/bash

# leave these here for backwards compat ^_^
APP_ROOT=$(pwd)
ORIGINAL_ISO_NAME=$1
NEW_ISO_NAME=$2
yespat='^(yes|y|YES|Y|aye?|AYE?)$'
happy=false
ISOTASK=mountiso

function print_separator {
    echo "===================================="
}

function install_pre_reqs {
    read -p "Install pre-reqs? > " resp && [[ $resp =~ $yespat ]] && {
        echo "Installing or updating squashfs-tools and syslinux"
        sudo apt-get update && sudo apt-get install squashfs-tools syslinux
    }
}

function happy_with_changes {
    customization_task=$1
    read -p "Are you happy with these changes? (y/n) > " resp
    happy=false
    [[ $resp =~ $yespat ]] && { 
        happy=true
        ISOTASK=$customization_task;
    }
    echo $unhappy
    echo "You can re-run this step by executing '$0 --entry $customization_task'" >&2
}

function do_we_continue {
    read -p "Do we continue to --entry $ISOTASK? > " resp
    continue_please=false
    [[ $resp =~ $yespat ]] && { 
        continue_please=true
    }
    [[ $continue_please = false ]] && {
        exit
    }
}

CLI_ARGUMENTS="$@"

. "$APP_ROOT/functions/print_help.sh"

. "$APP_ROOT/functions/parse_cli_args.sh"

install_pre_reqs

print_separator

[[ $ISOTASK = 'mountiso' ]] && {
    . "$APP_ROOT/functions/mountiso.sh"
    print_separator
    ISOTASK=customizeiso
    do_we_continue
} 

[[ $ISOTASK = 'customizeiso' ]] && {
    while [ $happy = false ]; do
        . "$APP_ROOT/functions/customizeiso.sh"
        happy_with_changes 'customizeiso'
        print_separator
    done
    happy=false
    ISOTASK=customizekernel
    do_we_continue
} 

[[ $ISOTASK = 'customizekernel' ]] && {
    while [ $happy = false ]; do
        . "$APP_ROOT/functions/customizekernel.sh"
        happy_with_changes 'customizekernel'
        print_separator
    done
    happy=false
    ISOTASK=buildiso
    do_we_continue
}

[[ $ISOTASK = 'buildiso' ]] && {
    . "$APP_ROOT/functions/buildiso.sh"
}
