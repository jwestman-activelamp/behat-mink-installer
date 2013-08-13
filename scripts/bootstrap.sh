#!/bin/bash
#
# Execute this installer by copying and pasting the following into a terminal:
# curl -L -s http://goo.gl/0VxD7M | bash
#
# The original bootstrap file may be viewed at:
# https://github.com/delphian/behat-mink-installer/blob/master/scripts/bootstrap.sh
#

echo -ne "Install php archives to directory (/usr/local/bin): "
read DESTINATION
if [ -z $DESTINATION ]; then
  DESTINATION="/usr/local/bin"
fi

echo -ne "Website (http://local.localhost.com): "
read WEBSITE
if [ -z $WEBSITE]; then
  WEBSITE="http://local.localhost.com"
fi

getsrc() {
  ( 
    cd $2 > /dev/null;
    curl -O $1;
    FILE=`echo $1 | sed 's/.*\///'`
    chmod $3 $FILE    
  )
}

getsrc http://behat.org/downloads/behat.phar $DESTINATION 744
getsrc http://behat.org/downloads/mink.phar $DESTINATION 644
getsrc http://behat.org/downloads/mink_extension.phar $DESTINATION 644

mkdir behat
cd behat
$DESTINATION/behat.phar --init

echo "#behat.yml
default:
  extensions:
    $DESTINATION/mink_extension.phar:
      mink_loader: '$DESTINATION/mink.phar'
      base_url:    '$WEBSITE'
      goutte:      ~
      selenium2:   ~
" >> behat.yml

curl -o $DESTINATION/selenium-server.jar http://selenium.googlecode.com/files/selenium-server-standalone-2.31.0.jar

