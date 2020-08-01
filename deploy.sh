#! /bin/bash

env -i git stash 
env -i git checkout develop
stack exec myblog clean
echo 'Building...'
stack exec myblog build
env -i git fetch --all
env -i git checkout -b master --track origin/master
echo 'Syncing...'
rsync -a --filter='P _site/' --filter='P _cache/' --filter='P .git/' --filter='P .gitignore' --filter='P .stack-work' --delete-excluded _site/ .
echo 'Publishing...'
env -i git add -A
env -i git commit -m 'Publish.'
env -i git push origin master:master
echo 'Successfully published. Switching back to development branch'
env -i git checkout develop
env -i git branch -D master
env -i git stash pop
