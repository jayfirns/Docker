#!/bin/bash

read -p "Enter your commit message: " commit_message

current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)

if [ -z "$current_branch" ]; then
    echo "You are not on a branch. Please switch to a branch and try again."
    exit 1
fi

git add .
git commit -m "$commit_message"

if [ $? -ne 0 ]; then
    echo "Commit failed. Please resolve any issues and try again."
    exit 1
fi

git push origin "$current_branch"

if [ $? -ne 0 ]; then
    echo "Push failed. Please resolve any issues and try again."
    exit 1
fi

echo "Changes successfully committed and pushed to the current branch: $current_branch."
