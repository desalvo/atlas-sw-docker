FROM cern/slc6-base
MAINTAINER Alessandro De Salvo "alessandro.desalvo@roma1.infn.it"

RUN rpm -i http://linuxsoft.cern.ch/wlcg/sl6/x86_64/wlcg-repo-1.0.0-1.el6.noarch.rpm
RUN yum install -y sudo util-linux curl git svn wget HEP_OSlibs_SL6 && yum clean all
RUN useradd -ms /bin/bash atlas
ADD sudoers.d/atlas /etc/sudoers.d/atlas
RUN mkdir -p /cvmfs/atlas.cern.ch/repo/{ATLASLocalRootBase,sw} && chown -R atlas.atlas /cvmfs

USER atlas
WORKDIR /home/atlas
RUN mkdir -p /home/atlas/bin
ADD bin /home/atlas/bin
ADD etc/arelinstrc /home/atlas/.arelinstrc
RUN svn co http://svn.cern.ch/guest/atcansupport/manageTier3SW/trunk /home/atlas/userSupport/manageTier3SW
RUN cd /home/atlas/userSupport/manageTier3SW && ./updateManageTier3SW.sh --alrbInstall=/cvmfs/atlas.cern.ch/repo --installOnly=asetup,cmake,dq2,agis,eiclient,emi,fax,gcc,gccxml,git,gsl,pacman,panda,pyami,python,rcsetup,rucio --noCronJobs
RUN echo 'export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase' >> ~/.bashrc && echo "alias setupATLAS='source \${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh'" >> ~/.bashrc

ADD entrypoint.sh /home/atlas/entrypoint.sh
ENTRYPOINT ["/home/atlas/entrypoint.sh"]
