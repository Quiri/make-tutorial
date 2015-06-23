# make-tutorial
My tutorial about make and bash for data science.
This repository was created to provide all the resources and the environment that I use in my talk about make and bash for R Users.

*A written down tutorial is in progress and will be published on my Blog (URL will be provided here)*.

### Dependencies
**This tutorial was designed for use on Debian based Linux systems**

To run the Virtual Machines you need 
  1. [Virtual Box](https://www.virtualbox.org/wiki/Linux_Downloads) (Tested on version 4.3.10)
  2. [Vagrant](https://www.vagrantup.com/downloads.html) (Tested on version 1.7.2)
  3. Make sure you virtualization is enabled in you BIOS (usually it is, but if you get an error, this might be a reason)
  
Make sure your **make** is compatible with GNU make (which is usually the case on Debian).

As a database server I use [PostgreSQL](http://www.postgresql.org/).

Furthermore you need [R](www.r-project.org) and the following R packages:
  1. data.table
  2. dplyr
  3. magrittr
  4. optparse
  5. readr
  6. RPostgreSQL
  7. devtools
  8. [wakefield](https://github.com/trinker/wakefield)

### Usage
#### Set up
To setup the environment run:
```bash
sh prepare.sh
```
This should set up the Virtual Machines (4 server), generate some random data, then push the data to the servers. It will also create some ssh-config for the VMs and create a PostgreSQL database named *datakraken*.

#### Run make
Now to see make in process change run:
```bash
cd tutorial
make -j 4 build
```

### License
FreeBSD License
