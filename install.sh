#!/bin/bash
#Script to install github pages with jekyll and rvm

command curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
\curl -sSL https://get.rvm.io | bash -s stable --ruby --with-gems="bundler"
source ~/.rvm/scripts/rvm
bundle install
echo "\nGithub-pages installed!\n"
echo "Press Enter to initialize webpage\n"
echo "Ctrl-c to stop.\n"
read nostop
echo "Enter your GitHub username:"
read username
jekyll new $username.GitHub.io
cd $username.GitHub.io
git init
git add .
git commit -m 'Initial commit'
curl -u $username https://api.github.com/user/repos -d '{"name":"'$username'.GitHub.io"}'
git remote add origin https://${username}@github.com/$username/$username.GitHub.io.git
git push origin master
