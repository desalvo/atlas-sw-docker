#!/bin/sh
set -e

: ${VO_ATLAS_SW_DIR:=/cvmfs/atlas.cern.ch/repo/sw}
: ${DBAREA:=${VO_ATLAS_SW_DIR}/database}
: ${TAGFILE:=${VO_ATLAS_SW_DIR}/tags}
: ${ATLAS_LOCAL_ROOT_BASE:=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase}
: ${DEBUG:=}
: ${RELEASE:=}
: ${INSTALL_OPTS:=}
: ${DBREL:=}

rc=0
export VO_ATLAS_SW_DIR

if [ ! -d $VO_ATLAS_SW_DIR ] ; then
  sudo mkdir -p $VO_ATLAS_SW_DIR
  sudo chown -R atlas.atlas $VO_ATLAS_SW_DIR
fi
[ -n "$DEBUG" ] && echo "Setting DBRelease"
if [ -n "$DBREL" -a ! -d ${DBAREA}/DBRelease/${DBREL} ] ; then
  DBAREA_OPT="--dbarea $DBAREA"
  /home/atlas/bin/sw-mgr -i $DBREL -p $DBAREA -P DBRelease -m 3.29 -n -o --no-tag -t noarch -T dbrelease --cvmfs-install
  rc=$?
fi
[ -n "$DEBUG" ] && echo "Setting Releases"
if [ $rc -eq 0 -a -n "$RELEASE" ] ; then
  for REL in `echo $RELEASE | sed 's/,/ /g'`; do
    echo "Setting Release $REL"
    /home/atlas/bin/updateAtlasReleases --skip-dbrelease --rel=$REL $DBAREA_OPT $INSTALL_OPTS
    [ $? -eq 0 ] || exit 1
    # Cleanup
    /usr/bin/find $VO_ATLAS_SW_DIR -name '.cvmfscatalog' -maxdepth 4 -exec rm -f {} \; 2>/dev/null
    /usr/bin/find $VO_ATLAS_SW_DIR -maxdepth 3 -type d -empty ! -path '*/o..pacman..o/*' -exec rm -fr {} \; 2>/dev/null
    [ -n "$DEBUG" ] && echo "Release $REL cleaned"
  done
  [ -n "$DEBUG" ] && echo "Installation completed"
fi
[ -n "$DEBUG" ] && echo "Installation completed [ALL]"
[ -n "$DEBUG" ] && echo "Executing $@"
$@
