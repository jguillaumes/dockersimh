#/bin/sh

###########################################################################
# Build all the base simh image
#
# Usage: buildall.sh 
#
###########################################################################

ARCHS="linux/arm64,linux/amd64,linux/arm/v7,linux/s390x"
TAGS="debian latest 3.1-debian 3.1 multiarch"
REPOID="jguillaumes"
PULLTAG="debian"
VERSION="3.1-debian"

generate_tags() {
    #+
    # $1: Base name
    # $2: List space-separated tags
    #-
    tags=""
    # echo $2
    for tag in $2; do
        # echo $tag
        tags="-t $REPOID/$1:$tag $tags" 
    done
    echo $tags
}

LOADARG="--push"


echo "Building the $REPOID/simh-allsims image for the $ARCHS architectures."
TAGARGS=$(generate_tags "simh-allsims" "$TAGS")
echo "TAGARGS=$TAGARGS"
docker buildx build --build-arg version=$VERSION $LOADARG --platform=$ARCHS $TAGARGS -f Dockerfile-allsims .
docker pull jguillaumes/simh-allsims:$PULLTAG

