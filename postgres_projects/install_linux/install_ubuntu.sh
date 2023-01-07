#!/usr/bin/env sh

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql

# Switch over to the postgres account on your server by typing:
sudo -i -u postgres
# Or
sudo -u postgres psql

# Check your current connection information
\conninfo

# List Databases
\l
