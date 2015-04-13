#!/bin/bash

#Script to install github pages with jekyll and rvm
if ruby -v | egrep -q '^ruby (1\.9|2)'; then
    echo "Ruby installed! Continuing..."
else
    echo "Github pages requires Ruby 1.9 or higher."
    read -n 1 -p "Install Ruby using Ruby Version Manager (Y/n)?"
    [ $REPLY == 'n' ] && { echo 'Please manually install Ruby.' ; exit 1; }
    gpg2 -? &> /dev/null && { echo 'Please install gpg (required for RVM)' ; exit 1; }
    command curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
    \curl -sSL https://get.rvm.io | bash -s stable --ruby
    source ~/.rvm/scripts/rvm
fi
gem install bundler
bundle install
echo "Github-pages installed!"
read -n 1 -p "Initialize website (Y/n)?"
[ $REPLY == 'n' ] && exit 0
echo ""
read -p "Enter your GitHub username: " username
# Check if Repo exists
if curl https://api.github.com/repos/$username/$username.GitHub.io | grep -q '"name": "'$username'.GitHub.io"'; then
    #repo found
    git clone https://${username}@github.com/$username/$username.GitHub.io.git $username.GitHub.io
else
    jekyll new $username.GitHub.io
    cd $username.GitHub.io
    git init
    git add .
    git commit -m 'Initial commit'
    echo "Creating remote repository:"
    curl -u $username https://api.github.com/user/repos -d '{"name":"'$username'.GitHub.io"}' > /dev/null
    printf "Enter your GitHub "
    git remote add origin https://${username}@github.com/$username/$username.GitHub.io.git
    git push origin master
fi
