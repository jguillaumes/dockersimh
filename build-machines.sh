#/bin/sh

###########################################################################
# Build all the machine specific images
#
# Usage: buildall.sh [-ba]
# 
#     -ba: Build also the -allsims image
#
###########################################################################

IMAGES="simh-pdpbsd simh-pdpv7 simh-vaxbsd simh-vaxnbsd simh-os8"
ARCHS="linux/arm64,linux/amd64,linux/arm/v7,linux/s390x"
LOADIMG="linux/arm64"
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

for i in $IMAGES; do
    FILESUF=`echo $i | cut -d'-' -f 2`
    TAGARGS=$(generate_tags $i "$TAGS")
    echo "Building image: $REPOID/$i based on Dockerfile-$FILESUF for the $ARCHS architectures"
    docker buildx build  --build-arg version=$VERSION $LOADARG --platform=$ARCHS $TAGARGS -f Dockerfile-$FILESUF .
    docker pull jguillaumes/$i:$PULLTAG
done

