#! /bin/bash

env -i git stash 
env -i git checkout develop
stack exec myblog clean
echo $'\nBuilding...'
stack exec myblog build
git checkout master
echo 'Syncing...'
rsync -a --filter='P _site/' --filter='P _cache/' --filter='P .git/' --filter='P .gitignore' --filter='P .stack-work' --delete-excluded _site/ .
echo $'\nPublishing...'
git add -A
git commit -m 'Publish last commit'
git push origin master
echo $'\nSuccessfully published. Switching back to development branch'
git checkout develop
env -i git stash pop
