#!/bin/bash

# Set the name of your remote (usually "origin" by default)
remote="origin"

# Get the name of the current branch
branch=$(git symbolic-ref --short HEAD 2>/dev/null)

if [ -z "$branch" ]; then
    echo "You are not on a branch. Please switch to a branch and try again."
    exit 1
fi

# Check if the branch exists on the remote repository
if ! git ls-remote --exit-code "$remote" "refs/heads/$branch" &> /dev/null; then
    echo "Branch \"$branch\" does not exist on remote \"$remote\"."
    # Create the branch on the remote repository and set up tracking
    git push -u "$remote" "$branch"
    # Check if the push was successful
    if [ $? -eq 0 ]; then
        echo "Branch \"$branch\" has been created on remote \"$remote\" and set up tracking."
    else
        echo "Failed to create branch \"$branch\" on remote \"$remote\"."
        exit 1
    fi
else
    # Push the current branch to the remote repository and set up tracking
    git push -u "$remote" "$branch"
    # Check the exit code of the git push command
    if [ $? -eq 0 ]; then
        echo "Successfully pushed branch \"$branch\" to \"$remote\" and set up tracking."
    else
        echo "Failed to push branch \"$branch\" to \"$remote\"."
        exit 1
    fi
fi
