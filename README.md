# atlas-sw-docker
ATLAS software relases docker implementation

#### Table of Contents
1. [Building the release container?](#building)
2. [Running the release container?](#running)

Building
--------

To build the generic, self-updating container, run the following command:

```build_container
cd atlas-sw-docker
build -t atlas-sw-docker:latest .
```

Running
-------

The container is able to auto-install specific releases, therefore you are adviced to mount shared storage for the release area. By default the container will install in /cvmfs/atlas.cern.ch/repo/sw inside the container. The release definitions are take from the installation system (https://atlas-install.roma1.infn.it/atlas_install), therefore the release names are the ones you can find there.

You can adjust the following parameters:

* **DBREL**: the DBRelease to be installed
* **RELEASE**: a comma-separated list of ATLAS software releases to be installed

Example of running a container, installing the DBRelease 31.5.1, software release 21.0.13 + 21.0.13.1 and dropping to a shell. The software repository area is shared with the host to have persistency:

```
docker run -it -e "DBREL=31.5.1" -e "RELEASE=21.0.13-x86_64,21.0.13.1-x86_64" --net=host --name=slc6-21.0.13.1 -v /docker/shared/atlas.cern.ch/repo/sw:/cvmfs/atlas.cern.ch/repo/sw  desalvo/slc6-atlassw /bin/bash
```

Contributors
------------

* https://github.com/desalvo/puppet-frontier/graphs/contributors

Release Notes
-------------

**0.1.0**

* Initial version.
