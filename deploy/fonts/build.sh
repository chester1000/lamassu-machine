#!/bin/bash
set -e

SCRIPT_DIR=$(dirname $0)

FONTS_ROOT=$1
FONT_PACKAGE=$2
EXPORT_ROOT=${3-$LAMASSU_EXPORT}

if [ -z "$EXPORT_ROOT" -o -z "$FONTS_ROOT" -o -z "$FONT_PACKAGE" ]
  then
    echo "Builds a lamassu-machine fonts package file for deploying to a device."
    echo -e "\nUsage:"
    echo -e "build <fonts directory> <font package> <target directory>\n"
    echo "Where the font package is a subdirectory of the fonts directory."
    echo "You may also set LAMASSU_EXPORT in lieu of <target directory>."
    exit 1
fi

SUB_DIR=fonts-$FONT_PACKAGE
EXPORT_BASE=$EXPORT_ROOT/$SUB_DIR
EXPORT_DIR=$EXPORT_BASE/package
UPDATESCRIPT=$SCRIPT_DIR/updateinit.js
MACHINE_DIR=$SCRIPT_DIR/../..
rm -rf $EXPORT_DIR
mkdir -p $EXPORT_DIR

# Needed for updateinit script on target device
cp $MACHINE_DIR/node_modules/async/lib/async.js $EXPORT_DIR
cp $SCRIPT_DIR/../report.js $EXPORT_DIR

# Fonts
cp -a $FONTS_ROOT/$FONT_PACKAGE $EXPORT_DIR/fonts

cp $UPDATESCRIPT $EXPORT_DIR/updatescript.js
cp $SCRIPT_DIR/fonts_css.js $EXPORT_DIR
cp $SCRIPT_DIR/remote_install $EXPORT_DIR
cp $SCRIPT_DIR/css/$FONT_PACKAGE.css $EXPORT_DIR/fonts.css

# Note, this is only needed for early release aaeons
mkdir -p $EXPORT_DIR/native/aaeon/scripts
cp $SCRIPT_DIR/updateinit-aaeon.js $EXPORT_DIR/native/aaeon/scripts/updateinit.js
cp $MACHINE_DIR/node_modules/async/lib/async.js $EXPORT_DIR/native/aaeon/scripts
cp $SCRIPT_DIR/../report.js $EXPORT_DIR/native/aaeon/scripts

node $SCRIPT_DIR/../build.js $EXPORT_BASE
