#!/usr/bin/env bash

# Time measurement
start=$(date +%s)

echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo "::: THIS SCRIPT WILL INSTALL EVERYTHING TO MAKE THIS MACHINE READY FOR KCSDB"
echo "::: PLEASE WAIT IF YOU THINK THE PROGRAM IS SLOW, IT IS WORKING IN THE BACKGROUND :)"
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"

echo "::::::::::::::::::::::"
echo "::: Update Apt Repo..." 
echo "::::::::::::::::::::::"
sudo apt-get update -y

echo ":::::::::::::::::::::::::::::"
echo "::: Installing Oracle Java..."
echo ":::::::::::::::::::::::::::::"
curl -L https://raw.github.com/flexiondotorg/oab-java6/master/oab-java.sh -s | sudo bash
sudo apt-get install sun-java6-jdk -y
export JAVA_HOME=/usr/lib/jvm/java-6-sun

echo "::::::::::::::::::::::::::::::::"
echo "::: Installing needed packages.."
echo "::::::::::::::::::::::::::::::::"
sudo apt-get install nodejs build-essential openssl libreadline6 libreadline6-dev curl git-core \
										 zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev \
										 autoconf libc6-dev ncurses-dev automake libtool bison subversion -y

echo ":::::::::::::::::::::::::::"
echo "::: Installing OpsCenter..."
echo ":::::::::::::::::::::::::::"
echo 'deb http://debian.datastax.com/community stable main' | sudo tee -a /etc/apt/sources.list # add repo
curl -L http://debian.datastax.com/debian/repo_key -s | sudo apt-key add - # add key
sudo apt-get update -y # update repo
sudo apt-get install opscenter-free -y # install opscenter

echo "::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo "::: Installing Gmetad..."
echo "::: [INFO] Always accept 'yes' for every question!!!"
echo "::::::::::::::::::::::::::::::::::::::::::::::::::::"
sudo apt-get install ganglia-webfrontend -y
sudo cp /etc/ganglia-webfrontend/apache.conf /etc/apache2/sites-enabled

echo "::::::::::::::::::::::::::::::"
echo "::: Installing Ruby via RVM..."
echo "::::::::::::::::::::::::::::::"
curl -L https://get.rvm.io -s | bash -s stable # load the install bash script
	
# update rvm variables
echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # This loads RVM into a shell session.' >> $HOME/.bashrc
. "$HOME/.rvm/scripts/rvm"

command rvm install 1.9.3 # rvm is NOT loaded into shell as a function

echo ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo "::: [INFO] Do NOT forget to set ruby 1.9.3 as default use"
echo "::: [INFO] $ . $HOME/.bashrc"
echo "::: [INFO] $ rvm --default use 1.9.3"
echo ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::"

# Time measurement
end=$(date +%s)

diff=$(( $end - $start ))

echo ":::::::::::::::::::::::::::::::::"
echo "::: Elapsed Time: $diff seconds!!"
echo ":::::::::::::::::::::::::::::::::"