#!/bin/bash

# Make sure to cd to the root repo dir
cd "$(git rev-parse --show-toplevel)"

# Update all submodules to track the latest commit on their respective branches
git submodule update --remote --merge

# Check if there are any changes in submodules
if [[ -n $(git diff --submodule) ]]; then
  # Stage only the submodule changes
  git add $(git submodule--helper foreach --quiet 'echo $sm_path')

  # Commit the changes
  git commit -m "Update submodules to the latest commit on their tracked branches"

  # Push the changes to the remote repo
  git push origin $(git rev-parse --abbrev-ref HEAD)
else
  echo "No changes detected in submodules. Nothing to commit."
fi
