#!/usr/bin/env bash

# Set the install directory #
#############################
workingdir=`pwd`

# Add the EPEL repository #
###########################

# Check if EPEL is installed
checkrepo=`yum repolist enabled | grep -i enterprise`

if [[ $checkrepo == *"epel"* ]]
  then
    echo "EPEL is already enabled" >> /dev/null
  else
    # Install the RPM file for the repo
    echo "# Will now install the epel repository #"
    echo "########################################"
    echo ""
    rpm -iUvh http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm

    # Perform a system update
    echo "# Will now perform a system update #"
    echo "####################################"
    echo ""
    yum -y update

# Install development tools #
#############################
echo "# Development Tools Group #"
echo "###########################"
echo ""
yum groupinstall -y 'development tools'
yum install -y 'zlib-dev openssl-devel sqlite-devel bzip2-devel'

# Install python #
##################
echo "# Installing python #"
echo "#####################"
echo ""
yum -y --enablerepo=epel install python python-devel python-pip python-boto python-json pyyaml

# Install ruby #
################
echo "# Installing ruby via rvm #"
echo "###########################"
echo ""
# First some ruby/rvm prerequisites
echo "# Ruby/RVM Prerequisites #"
echo ""
yum -y --enablerepo=epel install gcc-c++ patch readline readline-devel zlib zlib-devel libyaml-devel libffi-devel make bzip2 autoconf automake libtool bison iconv-devel"

# Next set up rvm
curl -sSL https://get.rvm.io | bash -s stable
source /usr/local/rvm/scripts/rvm
rvm use --install 1.9.3
shift
if (( $# ))
  then
    gem install $@
fi

# Install java #
################
echo "# Installing OpenJDK #"
echo "######################"
echo ""
yum -y install java-1.7.0-openjdk

# Install additional sysadmin tools #
#####################################
echo "# Installing sysadmin tools #"
echo "#############################"
yum -y --enablerepo=epel install vim htop sysstat nmap lsof telnet chkconfig tmux unzip pwgen vim-enhanced irssi screen json_diff json_simple

# Install awscli #
##################
echo "# AWS CLI Installation #"
echo "########################"
pip install awscli

# Create a non-vagrant user #
#############################
echo "# Will run useradd to create a non-vagrant user #"
echo "#################################################"
echo ""
useradd -d /home/tthompson -G admins,adm,wheel,vboxuser tthompson


# Set the system hostname #
###########################
echo "# Setting the system hostname #"
echo "###############################"
echo ""
sed -i '/HOSTNAME/d' /etc/sysconfig/network
echo "HOSTNAME=thompsonwork" >> /etc/sysconfig/network

fi
