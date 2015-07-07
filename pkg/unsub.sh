#!/bin/bash
set -e
[ -z "$UNSUB_ROOT" -a -d unsub -a -f unsub.sh ] && UNSUB_ROOT=unsub
UNSUB_ROOT=${UNSUB_ROOT:-/opt/unsub}
export BUNDLE_GEMFILE="$UNSUB_ROOT/vendor/Gemfile"
unset BUNDLE_IGNORE_CONFIG
exec "$UNSUB_ROOT/ruby/bin/ruby" -rbundler/setup "$UNSUB_ROOT/bin/unsub" $@