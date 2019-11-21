#!/bin/bash

set -ex

# Use defaults if not provided in environment
: ${DEBFULLNAME:=bot}
: ${DEBEMAIL:=bot@address.local}
: ${SIGN_FLAGS:=-us -uc}
: ${DISTRIB:=UNRELEASED}

export DEBFULLNAME DEBEMAIL

if [ -f "${PUBKEY_FILE}" ]; then
    chmod 700 $HOME/.gnupg
    gpg --import ${PUBKEY_FILE}
fi

PROJECT=$(basename $(pwd))
UPSTREAM_VERSION=$(git grep AC_INIT master:configure.ac | sed -ne 's/.*\[\(.*\)\].*/\1/p')
read DATE SHORTHASH LONGHASH <<<$(git log -1 --date=format:"%Y%m%d%H%M" --pretty=format:"%cd %h %H" master)
DEB_VERSION=${UPSTREAM_VERSION}~${DATE}.${SHORTHASH}

dch -D ${DISTRIB} -v ${DEB_VERSION}-1 -U "Nightly build from tag ${LONGHASH}"
git archive --format=tar --prefix=${PROJECT}-${DEB_VERSION}/ master | gzip -c > ${PROJECT}_${DEB_VERSION}.orig.tar.gz
tar xf ${PROJECT}_${DEB_VERSION}.orig.tar.gz
cd ${PROJECT}-${DEB_VERSION}
cp -a ../debian .
yes | mk-build-deps --install --remove
dpkg-buildpackage -rfakeroot ${SIGN_FLAGS}
