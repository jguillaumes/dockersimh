#/bin/sh

###########################################################################
# Build all the simh images, optionally including the base -allsims image
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

if [ "$1" == "-ba" ]; then
    echo "Building the $REPOID/simh-allsims: image for the $ARCHS architectures."
    TAGARGS=$(generate_tags "simh_allsims" "$TAGS")
    docker buildx build $LOADARG --platform=$ARCHS $TAGARGS -f Dockerfile-allsims .
    docker pull jguillaumes/simh-allsims:$PULLTAG
fi

for i in $IMAGES; do
    FILESUF=`echo $i | cut -d'-' -f 2`
    TAGARGS=$(generate_tags $i "$TAGS")
    echo "Building image: $REPOID/$i based on Dockerfile-$FILESUF for the $ARCHS architectures"
    docker buildx build  $LOADARG --platform=$ARCHS $TAGARGS -f Dockerfile-$FILESUF .
    docker pull jguillaumes/$i:$PULLTAG
done

