# Building a Docker containerized simh

## WARNING AND DISCLAIMER

This software is a hobby project, done in my free time just to amuse myself. It is not a serious attempt to build commercial-grade software. You can use it and follow this instructions at your own risk. I will not take any responsability if this breaks your computer, burns your house or makes your other-significant-one to file divorce against you. Just enjoy it and (hopefully) have fun!

## Repository and image contents

This repository contains the files needed to build a containerized version of simh. The resulting docker image will be debian-based
and will contain:

- The gcc compiler, needed to build simh
- GNU Make
- Git support
- VDE support
- net-tools to manipulate the network stack
- libpcap to enable certain features of simh networking
- the nano editor to edit simh configuration files
- A pair of example configuration files for VAX and PDP11 simulators.

It will **not** contain any OS image for the simulators. 

## Building the image

To build the simh images, we will build first a "base" image with the needed packages and the simh source already cloned. 
This will enable building different simh containers without incurring in the overhead of downloading again the needed packages. 
We will build the base image issuing this command:
```
docker build -t jguillaumes/simh-base -f Dockerfile-base .
```

You can change the tag name if you wish, but the you will have to modify the Dockerfile used to build simh images accordingly.

Once you have built the base image, you can build any number of simh images. To do so, issue the command:

```
docker build -t <yourtag> [--build-arg buildsims="<simulators to build>"] .
```

You can specify which simulators you want to build specifying the ```buildsims```argument, which should be a blank-separated list of
make targers. The default value is ```"vax pdp11"```, so the Microvax 3900 and the PDP-11 simulators will be built. So if you want, for instance,  to
build the Altairs simulator you will issue:

```
docker build -t <yourtag> --build-arg buildsims="altair altairz80" .
```

## Adding guest OS images and adjusting your configuration

Everything under the ```machines``` subdirectory will be copied verbatim to the /machines directory in the container. This repository 
contains just two subdirectories, ```vax```and ```pdp11```, each one with a sample configuration file. You can add your own subdirectories,
configuration files and disk images and those will be copied to the docker image.

The default network configuration exposes the TCP 2323 port, which is the one the serial devices in the sample PDP11 and VAX configurations
is attached to. You should change this if you plan to use other ports, or if you plan to expose other services (for instance,
the console port, or the synchronous communication devices port).

The image defines the /machines volume, which can be mounted in your containers as shown below.

## Using the built images

### Default configuration

To create a container from the default image, you can issue this command:

```
docker run --name <container_name> -p 2323:2323 -it <your_image_tag>
```
This will create a container using the contents of the ```machines``` subdirectory and will run a bash shell with that one set as
default working directory. You can then setup your VAX or PDP11 guest using whatever means you have (probably using ```docker cp``` 
to upload your distribution media or disk images into the container). 

To detach from the running container, use CTRL-P CTRL-Q. To reattach to a running container use ```docker attach <container_namer>```. To stop the container you can use ```docker stop <container_name>``` from your host environment, but this is not recommended since you should shut down your guest OS properly. So please ```docker attach``` to your guest, ```RUN $SHUTUP```, ```@SYS$SYSTEM:SHUTDOWN```  or whatever your OS needs to shut down and then simply exit from simh and the bash shell to stop the container.

To start a docker container, issue ```docker start <conainer_name>``` followed by ```docker attach```. 

### Using an image and configuration from your host filesystem

You can use a directory in your host filesystem to store guest images and configurations. Remember ```/machines``` is a mountable volume, so you can do:

```
docker run --name <container_name> -p 2323:2323 -v <your_filesystem_path>:/machines -it <your_image_tag> [simulator]
```

This command will mount ```<your_filesystem_path>``` into /machines inside the container, so you can run your simulated machines using resources in the host. The optional parameter ```simulator``` allows you to start immediately a program instead of opening a bash shell,
so your container will boot immediately into simh.

## Networking

### TCP/IP

The container can do outbound tcp/ip communications _out of the box_. If you want to enable inbound communications (ie, the capability of telneting into your simulators from the host machine or the outside world) you will need to add the corresponding entries to the routing tables of your host and/or your local router.

Please take note this does not currently work with the xhyve based beta release of Docker for OSX, since the containers inside that environent are not currently routable. It does work with the _docker-machine_ based versions which uses a virtualbox VM.

### DECNET

The containers running inside the same docker-machine (or host) will see each other and will be able to communicate using DECNET. To enabe them to talk to the outside world you will need to use one of the several available methods (SIMH synchronous devices, Multinet-based DECNET-over-IP, vde under a ssh tunnel or the DECNET bridge program by Johnny Bilquist).





