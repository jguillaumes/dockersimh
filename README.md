# Building a Docker containerized simh

## WARNING AND DISCLAIMER

This software is a hobby project, done in my free time just to amuse myself. It is not a serious attempt to build commercial-grade software. You can use it and follow this instructions at your own risk. I will not take any responsability if this breaks your computer, burns your house or makes your other-significant-one to file divorce against you. Just enjoy it and (hopefully) have fun!

## Repository and image contents

This repository contains files to build containerized versions of simh. There are several files available, which correspond to different images with different contents. At this moment, the list of Dockerfiles and images is:

- **Dockerfile-allsims**: Makes an image which contains the binaries for all the simh simulators. This image does not contain neither configuration samples nor OS image files.
- **Dockerfile-pdpbsd**: Makes an image which contains the PDP-11 simulator and a ready to run BSD 2.11 image.
- **Dockerfile-vaxbsd**: Makes an image which contains the VAX 11/780 simulator and a ready to run BSD 4.3 image.
- **Dockerfile-vaxnbsd**: Makes an image which contains the VAX (Microvax 3900) simulator and a ready to run NetBSD 6.0 image.
- **Dockerfile-os8**: Makes an image which contains the PDP-8 simulator and a ready to run OS/8 image.
- **Dockerfile**: Makes an image which contains the PDP-11, VAX (Microvax 3900) and VAX780 simulators, with sample configuration files for PDP-11 and VAX and **no** image OS.

There are two versions of the images, based on different Linux distributions and implemented in two different git branches. They *should* match but this is not guaranteed.

### ```master``` branch

The images are based upon the alpine Linux distribution. Alpine is a very lightweight distribution built around a statically linked busybox executable. The dockerfiles add to alpine the components needed to run and to build simh. The build time components are erased before completing the image to avoid bloating it. This distribution uses the ```mulc``` library instead of ```glibc```. SIMH console handle has some incompatibility with that library, the most visible point being SIMH does not show its prompt.

### ```debian``` branch

The images are based upon the debian distribution. That base image is much bigger, but provides more content and, what is more important, is based on the standard glibc. The shell used is the standard ```bash``` shell.

The debian ```libpcap``` packages include bluetooth support. For some reason, that requires a container loading libpcap must be run as privileged. To avoid that, the debian branch includes two ```.deb``` files with libpcap built without bluetooth.

## Building the images

You shoud build first the image from Dockerfile-allsims, since it is needed to build the other images. You can select any tag for the image, but please remember to update the other dockerfiles to reference the one you chose. The default is ```jguillaumes/simh-allsims```.

This repository contains the compressed OS images for BSD 2.11 for the PDP-11 and BSD 4.3 for the VAX, but it **does not** contain the NetBSD image, since it is quite big (about 260MB). If you want to build the NetBSD container you can download the disk image and the empty volume template using these two links:

- https://drive.google.com/open?id=0B2q64Hq0IZ1WNTZuajNFM3g3dnM

- https://drive.google.com/open?id=0B2q64Hq0IZ1WRGhaREZWZThzM0U

The commands to build the images are as follows. Remember you can change the tags as you wish.

```
docker build -t jgullaumes/simh-allsims -f Dockerfile-allsims .
docker build -t jgullaumes/simh-pdpbsd -f Dockerfile-pdpbsd .
docker build -t jgullaumes/simh-vaxbsd -f Dockerfile-vaxbsd .
docker build -t jgullaumes/simh-os8 -f Dockerfile-os8 .
docker build -t jgullaumes/simh-vax [--build-arg sims="<simulator list>"] .

# Remember to download the NetBSD disks before building the next image!
docker build -t jgullaumes/simh-vaxnbsd -f Dockerfile-vaxnbsd .
```

You can optionally specify the list of simulators you want to be available in simh-vax specifying it as the optional parameter ```--build-args```. The default is ```"vax vax780 vax8600 pdp11 pdp8"```.

There is a shell script which builds all those images:

```buildall.sh [-ba]```

If you don't include the ```-ba``` switch, all the images EXCEPT simh-allsims will be built. If you include -ba then it will be included in the build.

## Adding guest OS images to simh-vax

Everything under the ```machines``` subdirectory will be copied verbatim to the /machines directory in the container. This repository
contains just two subdirectories, ```vax```and ```pdp11```, each one with a sample configuration file. You can add your own subdirectories,
configuration files and disk images and those will be copied to the docker image.

The default network configuration exposes the TCP 2323 port, which is the one the serial devices in the sample PDP11 and VAX configurations
is attached to. You should change this if you plan to use other ports, or if you plan to expose other services (for instance,
the console port, or the synchronous communication devices port).

The image defines the /machines volume, which can be mounted in your containers as shown below.

## Using the built images

### Default configuration (simh-vax)

To create a container from the default image, you can issue this command:

```
docker run [--name <your_container_name>] -p 2323:2323 -it jguillaumes/simh-vax
```
This will create a container using the contents of the ```machines``` subdirectory and will run a sh shell (busybox) with that one set as
default working directory. You can then setup your VAX or PDP11 guest using whatever means you have (probably using ```docker cp```
to upload your distribution media or disk images into the container).

To detach from the running container, use CTRL-P CTRL-Q. To reattach to a running container use ```docker attach <container_namer>```. To stop the container you can use ```docker stop <container_name>``` from your host environment, but this is not recommended since you should shut down your guest OS properly. So please ```docker attach``` to your guest, ```RUN $SHUTUP```, ```@SYS$SYSTEM:SHUTDOWN```  or whatever your OS needs to shut down and then simply exit from simh and the bash shell to stop the container.

To start a docker container, issue ```docker start <container_name>``` followed by ```docker attach```.

### Using an image and configuration from your host filesystem

You can use a directory in your host filesystem to store guest images and configurations. Remember ```/machines``` is a mountable volume, so you can do:

```
docker run --name <container_name> -p 2323:2323 -v <your_filesystem_path>:/machines -it <your_image_tag> [simulator]
```

This command will mount ```<your_filesystem_path>``` into /machines inside the container, so you can run your simulated machines using resources in the host. The optional parameter ```simulator``` allows you to start immediately a program instead of opening a bash shell,
so your container will boot immediately into simh.

## PDP-11 or VAX with BSD

To run a container with the PDP-11 or VAX780 simulator and BSD, issue the following command:

```
docker run --name <container_name> -p 2323:2323 -it <your_image_tag_for_pdpbsd>
```
It will boot straight into BSD.

In the PDP-11 simulator you will have to press Enter to start the boot process, and CTRL-D to close the single user shell and boot into multiuser. This image has networking set up. Please change the configuration in /etc/netstart, /etc/hosts, /etc/networks and /etc/resolv.conf to match your setup.

In the VAX simulator it will boot right until the ```login:``` prompt. The files you must adjust to your networking setup are /etc/rc.local, /etc/hosts, /etc/networks and /etc/resolv.conf.

**Warning**: The image has a configured DNS server that will probably not be available in your network. During the boot process there are DNS requests, which will stall and wait until their timeout, so the boot can seem to be "hung". Please be patient, wait for the boot to finish and then fix /etc/resolv.conf. Alternatively, you can do from single user before allowing the boot to continue.


## Networking

### TCP/IP

The container can do outbound tcp/ip communications _out of the box_. If you want to enable inbound communications (ie, the capability of telneting into your simulators from the host machine or the outside world) you will need to add the corresponding entries to the routing tables of your host and/or your local router.

Please take note this does not currently work with the xhyve based beta release of Docker for OSX, since the containers inside that environent are not currently routable. It does work with the _docker-machine_ based versions which uses a virtualbox VM.

### DECNET

The containers running inside the same docker-machine (or host) will see each other and will be able to communicate using DECNET. To enabe them to talk to the outside world you will need to use one of the several available methods (SIMH synchronous devices, Multinet-based DECNET-over-IP, vde under a ssh tunnel or the DECNET bridge program by Johnny Bilquist). You will have to EXPOSE additional ports to set up your chosen method.

## Bugs and annoyances

Right now the simh simulator does not display its prompt. It works and accepts typed commands, but does not show neither the default ```sim>``` prompt nor any customized one you set.
