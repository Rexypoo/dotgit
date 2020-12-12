#!/usr/bin/env bash

# This script assumes .git is already installed
# Potentially, a remote repository has been added

BRANCH="${1:-main}"

function .git {
  git --git-dir="$HOME"/.config/dotgit --work-tree="$HOME" "$@"
}

if .git checkout $BRANCH; then
  echo "Success! No conflicts."
else

  # Set up backup information
  BACKUP_DIR="$(.git rev-parse --git-dir)-backups"
  TIMESTAMP="$(date --utc +%Y%m%dT%H%M%SZ)"
  BACKUP_PATH="$BACKUP_DIR/$TIMESTAMP"
  mkdir -p "$BACKUP_PATH"

  # Find files to back up
  HOMEDIR="$(.git rev-parse --show-toplevel)"
  CONFLICTS="$(.git checkout $BRANCH 2>&1 | grep '^[[:space:]]' | sed 's/^[[:space:]]*//')"

  echo
  echo "Attempting to stash conflicts"
  echo "--------------------------------"

  # If we're already on a working branch, stash our information
  for CONFLICT in ${CONFLICTS[@]}; do
    echo "Attempting to track $CONFLICT"
    .git add "$HOMEDIR/$CONFLICT"
  done
  echo
  .git stash push -m "$TIMESTAMP Stash before checkout of $BRANCH"

  echo
  echo "Attempting to move conflicts"
  echo "--------------------------------"

  # In case we weren't already on a working branch, create file backups 
  for CONFLICT in ${CONFLICTS[@]}; do
    # dirname does something odd with dotfiles on relative paths...
    if [[ "$CONFLICT" == */* ]]; then
      CONFLICT_DIR="$(dirname $CONFLICT)"
      mkdir -p "$BACKUP_PATH/$CONFLICT_DIR"
    fi
    # In case stash failed, untrack conflicts
    .git rm --cached "$HOMEDIR/$CONFLICT" 1>/dev/null 2>&1
    echo "Attempting to move $HOMEDIR/$CONFLICT to $BACKUP_PATH/$CONFLICT"
    mv "$HOMEDIR/$CONFLICT" "$BACKUP_PATH/$CONFLICT"
  done

  echo
  echo "Re-attempting checkout"
  echo "--------------------------------"

  .git checkout $BRANCH
fi
