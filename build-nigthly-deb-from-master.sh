#!/bin/bash

set -ex

export DEBFULLNAME="bot"
export DEBEMAIL="bot@address.local"

PROJECT=$(basename $(pwd))
UPSTREAM_VERSION=$(git grep AC_INIT master:configure.ac | sed -ne 's/.*\[\(.*\)\].*/\1/p')
read DATE SHORTHASH LONGHASH <<<$(git log -1 --date=format:"%Y%m%d%H%M" --pretty=format:"%cd %h %H" master)
DEB_VERSION=${UPSTREAM_VERSION}~${DATE}.${SHORTHASH}

dch -v ${DEB_VERSION}-1 -U "Nightly build from tag ${LONGHASH}"
git archive --format=tar --prefix=${PROJECT}-${DEB_VERSION}/ master | gzip -c > ${PROJECT}_${DEB_VERSION}.orig.tar.gz
tar xf ${PROJECT}_${DEB_VERSION}.orig.tar.gz
cd ${PROJECT}-${DEB_VERSION}
cp -a ../debian .
yes | mk-build-deps --install --remove
dpkg-buildpackage -rfakeroot -us -uc
