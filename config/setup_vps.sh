#!/bin/sh
echo "starting..."
# check for correct number of arguments
if [ $# -ne 3 ]; then
  echo "Usage: $0 <user> <ip> <port>"
  exit 1
fi

# set variables
USER=$1
IP=$2
PORT=$3

# upload key for root
ssh-copy-id -i ~/.ssh/id_rsa.pub root@$IP
#
# # install chef
cd config/chef && knife solo prepare root@$IP

# execute the run list
# knife solo cook root@$IP
#
# upload key for user
# ssh-copy-id -i ~/.ssh/id_rsa.pub -p $PORT $USER@$IP
#
# # upload app
# cd ../.. && cap production setup:all
#
# # restart nginx
# ssh -p $PORT -t $USER@$IP 'sudo service nginx restart'
