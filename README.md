# Building a Docker containerized simh

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




