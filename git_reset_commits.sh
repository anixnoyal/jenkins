git checkout --orphan new-branch
git add .
git commit -m "Initial commit (history removed)"
git branch -D main
git branch -m main
git push --force origin main
