#!/bin/bash

ORIGINAL_ISO_NAME='decoy'
NEW_ISO_NAME='decoy2'
ISOTASK='decoy3'

CLI_ARGUMENTS="--iniso=z.iso --outiso=zz.iso --entry def"
. 'functions/parse_cli_args.sh'

test_original_iso_name='z.iso'
test_new_iso_name='zz.iso'
test_isotask='def'

[[ "$test_original_iso_name" = "$ORIGINAL_ISO_NAME" ]] && {
   echo "SUCCESS: $0 passes test_original_iso_name $test_original_iso_name = $ORIGINAL_ISO_NAME"; 
}
[[ "$test_new_iso_name" = "$NEW_ISO_NAME" ]] && {
   echo "SUCCESS: $0 passes test_new_iso_name $test_new_iso_name = $NEW_ISO_NAME"; 
}
[[ "$test_isotask" = "$ISOTASK" ]] && {
   echo "SUCCESS: $0 passes test_original_iso_name $test_original_iso_name = $ISOTASK"; 
}

# Note that these tests look for failures, not successes
[[ "$test_original_iso_name" != "$ORIGINAL_ISO_NAME" ]] && {
   echo "FAILURE: $0 fails test_original_iso_name $test_original_iso_name != $ORIGINAL_ISO_NAME"; 
}
[[ "$test_new_iso_name" != "$NEW_ISO_NAME" ]] && {
   echo "FAILURE: $0 fails test_new_iso_name $test_new_iso_name != $NEW_ISO_NAME"; 
}
[[ "$test_isotask" != "$ISOTASK" ]] && {
   echo "FAILURE: $0 fails test_original_iso_name $test_original_iso_name != $ISOTASK"; 
}
