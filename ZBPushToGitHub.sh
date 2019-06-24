
#! /bin/bash

echo "pod update..."

git add .
git commit  -m "修改podspec"
git tag "1.0.0"
git push origin master
git push --tags
#pod trunk push ZBFancyTableView.podspec --allow-warnings
