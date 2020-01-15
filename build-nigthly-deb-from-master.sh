#!/bin/bash

set -ex

# Use defaults if not provided in environment
: ${DEBFULLNAME:=bot}
: ${DEBEMAIL:=bot@address.local}
: ${SIGN_FLAGS:=-us -uc}
: ${DISTRIB:=UNRELEASED}
: ${BUILD_OPTS:=-F}

export DEBFULLNAME DEBEMAIL

if [ -f "${PUBKEY_FILE}" ]; then
    chmod 700 $HOME/.gnupg
    gpg --import ${PUBKEY_FILE}
fi

PROJECT=$(basename $(pwd))-mingw-w64
UPSTREAM_VERSION=$(git grep AC_INIT master:configure.ac | sed -ne 's/.*\[\(.*\)\].*/\1/p')
read DATE SHORTHASH LONGHASH <<<$(git log -1 --date=format:"%Y%m%d%H%M" --pretty=format:"%cd %h %H" master)
UPSTREAM_HASH=${DATE}.${SHORTHASH}
TARBALL_VERSION=${UPSTREAM_VERSION}~${UPSTREAM_HASH}
BUILD_INFO=${DISTRIB}.1
DEB_VERSION=${TARBALL_VERSION}-${BUILD_INFO}

dch -D ${DISTRIB} -v ${DEB_VERSION} -U "Nightly build from tag ${LONGHASH}"
git archive --format=tar --prefix=${PROJECT}-${TARBALL_VERSION}/ master | gzip -nc > ${PROJECT}_${TARBALL_VERSION}.orig.tar.gz
tar xf ${PROJECT}_${TARBALL_VERSION}.orig.tar.gz
cd ${PROJECT}-${TARBALL_VERSION}
cp -a ../debian .
yes | mk-build-deps --install --remove
dpkg-buildpackage -rfakeroot ${BUILD_OPTS} ${SIGN_FLAGS}
