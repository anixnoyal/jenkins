#!/bin/bash

REPO_PATH="/path/to/your/repo"
BRANCH_PREFIX="feature-branch"
MAIN_BRANCH="main"
GIT_REMOTE="origin"

# Navigate to repo
cd "$REPO_PATH" || exit

# Fetch latest changes
git checkout $MAIN_BRANCH
git pull $GIT_REMOTE $MAIN_BRANCH

# Create 25 branches if not exist
for i in {1..25}; do
    BRANCH_NAME="${BRANCH_PREFIX}-$i"
    if ! git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
        git checkout -b "$BRANCH_NAME" $MAIN_BRANCH
        git push -u $GIT_REMOTE "$BRANCH_NAME"
    fi
done

# Commit and create merge requests every 30 seconds
while true; do
    for i in {1..25}; do
        BRANCH_NAME="${BRANCH_PREFIX}-$i"
        
        git checkout "$BRANCH_NAME"
        
        # Make a dummy change
        echo "Update on $(date)" >> changes.txt
        git add changes.txt
        git commit -m "Automated update $(date)"
        
        # Push changes
        git push $GIT_REMOTE "$BRANCH_NAME"
        
        # Create merge request (GitHub CLI: `gh`, GitLab CLI: `glab`)
        if command -v gh &>/dev/null; then
            gh pr create --base "$MAIN_BRANCH" --head "$BRANCH_NAME" --title "Merge $BRANCH_NAME" --body "Automated merge request"
        elif command -v glab &>/dev/null; then
            glab mr create --source "$BRANCH_NAME" --target "$MAIN_BRANCH" --title "Merge $BRANCH_NAME" --yes
        else
            echo "GitHub CLI (gh) or GitLab CLI (glab) not found!"
        fi

        # Approve and merge (modify based on GitHub/GitLab)
        if command -v gh &>/dev/null; then
            PR_ID=$(gh pr list --head "$BRANCH_NAME" --json number --jq ".[0].number")
            [ -n "$PR_ID" ] && gh pr review "$PR_ID" --approve && gh pr merge "$PR_ID" --merge
        elif command -v glab &>/dev/null; then
            MR_ID=$(glab mr list --source "$BRANCH_NAME" --json | jq -r '.[0].id')
            [ -n "$MR_ID" ] && glab mr approve "$MR_ID" && glab mr merge "$MR_ID"
        fi
    done

    sleep 30
done
