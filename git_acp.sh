#!/bin/bash

read -p "Enter your commit message: " commit_message

git add .
git commit -m "$commit_message"

if [ $? -ne 0 ]; then
    echo "Commit failed. Please resolve any issues and try again."
    exit 1
fi

git push origin main

if [ $? -ne 0 ]; then
    echo "Push failed. Please resolve any issues and try again."
    exit 1
fi

echo "Changes successfully committed and pushed to the main branch."
