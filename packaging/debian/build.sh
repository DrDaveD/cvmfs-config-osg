#!/bin/sh

set -e

#
# This script used for package creation and debugging
#

PKG=cvmfs-config-osg

usage() {
  echo "Sample script that builds the $PKG debian package from source"
  echo "Usage: $0"
  exit 1
}

if [ $# -ne 0 ]; then
  usage
fi

workdir=/tmp/build-$PKG
srctree=$(readlink --canonicalize ../..)

if [ "$(ls -A $workdir 2>/dev/null)" != "" ]; then
  echo "$workdir must be empty"
  exit 2
fi

echo -n "creating workspace in $workdir... "
mkdir -p ${workdir}/tmp ${workdir}/src ${workdir}/result
echo "done"

echo -n "copying source tree to $workdir/tmp... "
cp -R $srctree/* ${workdir}/tmp
echo "done"

echo -n "initializing build environment... "
mkdir ${workdir}/src/$PKG
cp -R $srctree/* ${workdir}/src/$PKG
mkdir ${workdir}/src/$PKG/debian
cp -R ${workdir}/tmp/packaging/debian/* ${workdir}/src/$PKG/debian
cp ${workdir}/tmp/packaging/debian/Makefile ${workdir}/src/$PKG
echo "done"

echo -n "figuring out version number from rpm packaging... "
upstream_version="`sed -n 's/^Version: //p' ../redhat/$PKG.spec`"
echo "done: $upstream_version"

echo "building..."
cd ${workdir}/src/$PKG
dch -v $upstream_version -M "bumped upstream version number"

cd debian
pdebuild --buildresult ${workdir}/result -- --save-after-exec --debug

echo "Results are in ${workdir}/result"