#!/bin/bash

# Containerised Dokuwiki, ready to rumble container.
# Minimal actions required

set -e

CONTAINER=$(basename `pwd`)
VOLUMES="Volumes.$CONTAINER"
PRESENTD=$(pwd)"/$VOLUMES"

newcontainer () {
	mkdir -p $VOLUMES/lib
	mkdir -p $VOLUMES/data
	mkdir -p $VOLUMES/conf
	echo "New Wiki volumes created"
}

# if $BASEDIR is empty, create volumes
if [ "mkdir $VOLUMES && $(ls -A $PRESENTD)" ]; then
	echo "Good to go..."
else
	newcontainer
fi


start () {
	echo "Starting Wiki $CONTAINER..."
	docker run -it -d \
	--name Dokuwiki.$CONTAINER \
	-v $PRESENTD/lib:/var/www/dokuwiki/lib:rw \
	-v $PRESENTD/data:/var/www/dokuwiki/data:rw \
        -v $PRESENTD/conf:/var/www/dokuwiki/conf:rw \
	-p 80:80 \
	benzies/dokuwiki:0.6

}

stop () {
    echo "Stopping and deleting all containers.."
    # The containers themselves are stateless (all data is stored in
    # this root directory), so always nuke them.
    docker rm -f Dokuwiki.$CONTAINER 2>/dev/null || true
}



if [ "$1" == "stop" ]; then
    stop
    exit 0
elif [ "$1" == "start" ]; then
    start
fi




# Options
## Check name of folder and create container based on that variable.
## e.g. folder pwd ~/Containers/Dokuwiki/Mine; docker run -d --name $PWD-dokuwiki
## Ask for port assignment, e.g. PORT=1080 $PORT:80
## Setup volumes into $PWD/data; Dokuwiki user data
## Setup volumes into $PWD/lib; Plugins directory.
## Setup volumes into $PWD/conf; Configuration settings.

