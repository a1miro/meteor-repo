#!/usr/bin/env bash

ARGS="$@"

CWD=`pwd`
POKYROOT=${CWD%"sources/meta-wheelme/scripts"}
SRCDIR="${POKYROOT}/sources"
BUILD_DIR="${POKYROOT}/build"
SETUPENV_DEV="${SRCDIR}/meta-wheelme-dev/scripts/wheelme-setenv.sh"
BBLAYERS_CONF="${BUILD_DIR}/conf/bblayers.conf"
LOCAL_CONF="${BUILD_DIR}/conf/local.conf"
DOCKER_SSTATE_YML="${POKYROOT}/docker-compose.sstate.yml"
IS_DEV=0

echo "================================================"
echo "starting script wheelme-setenv.sh               "
echo "================================================"


echo "ARGS = ${ARGS}"
echo "POKYROOT = ${POKYROOT}"
echo "BUILD_DIR=${BUILD_DIR}"

VAR_SETUP_SCRIPT="${SRCDIR}/poky/oe-init-build-env"
source ${VAR_SETUP_SCRIPT} ${ARGS}

srcdir="SRCDIR := \"\${@os.path.abspath(os.path.join('\${TOPDIR}', os.pardir, \"sources\"))}\""

egrep "^\s*SRCDIR\s*:=.*$" ${BBLAYERS_CONF} &> /dev/null
if [ $? -ne "0" ] ; then
  echo "" >> ${BBLAYERS_CONF}
  echo  "${srcdir}" >> ${BBLAYERS_CONF}
fi

grep -E "^BBLAYERS[[:space:]]?\+\=[[:space:]]?\"\\$\{SRCDIR}\/meta-openembedded\/meta-oe\"[[:space:]]?$" ${BBLAYERS_CONF} &> /dev/null
if [ $? -ne "0" ] ; then
  echo 'BBLAYERS += "${SRCDIR}/meta-openembedded/meta-oe"' >> ${BBLAYERS_CONF}
fi

grep -E "^BBLAYERS[[:space:]]?\+\=[[:space:]]?\"\\$\{SRCDIR}\/meta-openembedded\/meta-python\"[[:space:]]?$" ${BBLAYERS_CONF} &> /dev/null
if [ $? -ne "0" ] ; then
  echo 'BBLAYERS += "${SRCDIR}/meta-openembedded/meta-python"' >> ${BBLAYERS_CONF}
fi

grep -E "^BBLAYERS[[:space:]]?\+\=[[:space:]]?\"\\$\{SRCDIR}\/meta-ros\/meta-ros1-noetic\"[[:space:]]?$" ${BBLAYERS_CONF} &> /dev/null
if [ $? -ne "0" ] ; then
  echo 'BBLAYERS += "${SRCDIR}/meta-ros/meta-ros1-noetic"' >> ${BBLAYERS_CONF}
fi

grep -E "^BBLAYERS[[:space:]]?\+\=[[:space:]]?\"\\$\{SRCDIR}\/meta-ros\/meta-ros1\"[[:space:]]?$" ${BBLAYERS_CONF} &> /dev/null
if [ $? -ne "0" ] ; then
  echo 'BBLAYERS += "${SRCDIR}/meta-ros/meta-ros1"' >> ${BBLAYERS_CONF}
fi

grep -E "^BBLAYERS[[:space:]]?\+\=[[:space:]]?\"\\$\{SRCDIR}\/meta-ros\/meta-ros1\"[[:space:]]?$" ${BBLAYERS_CONF} &> /dev/null
if [ $? -ne "0" ] ; then
  echo 'BBLAYERS += "${SRCDIR}/meta-ros/meta-ros1"' >> ${BBLAYERS_CONF}
fi

grep -E "^BBLAYERS[[:space:]]?\+\=[[:space:]]?\"\\$\{SRCDIR}\/meta-ros\/meta-ros-common\"[[:space:]]?$" ${BBLAYERS_CONF} &> /dev/null
if [ $? -ne "0" ] ; then
  echo 'BBLAYERS += "${SRCDIR}/meta-ros/meta-ros-common"' >> ${BBLAYERS_CONF}
fi

#grep -E "^BBLAYERS[[:space:]]?\+\=[[:space:]]?\"\\$\{SRCDIR}\/meta-ros\/meta-ros-backports-hardknott\"[[:space:]]?$" ${BBLAYERS_CONF} &> /dev/null
#if [ $? -ne "0" ] ; then
#  echo 'BBLAYERS += "${SRCDIR}/meta-ros/meta-ros-backports-hardknott"' >> ${BBLAYERS_CONF}
#fi

grep -E "^BBLAYERS[[:space:]]?\+\=[[:space:]]?\"\\$\{SRCDIR}\/meta-tegra\"[[:space:]]?$" ${BBLAYERS_CONF} &> /dev/null
if [ $? -ne "0" ] ; then
  echo 'BBLAYERS += "${SRCDIR}/meta-tegra"' >> ${BBLAYERS_CONF}
fi

# Update bblayers.conf with wheelme metalayers
grep -E "^BBLAYERS[[:space:]]?\+\=[[:space:]]?\"\\$\{SRCDIR}\/meta-wheelme\"[[:space:]]?$" ${BBLAYERS_CONF} &> /dev/null
if [ $? -ne "0" ] ; then
  echo 'BBLAYERS += "${SRCDIR}/meta-wheelme"' >> ${BBLAYERS_CONF}
fi

## Check if this is going to be a development build
#if [ -d "${SRCDIR}/meta-wheelme-dev" ] ; then
#  grep -E "^BBLAYERS[[:space:]]?\+\=[[:space:]]?\"\\$\{SRCDIR}\/meta-wheelme-dev\"[[:space:]]?$" ${BBLAYERS_CONF} &> /dev/null
#  if [ $? -ne "0" ] ; then
#    echo 'BBLAYERS += "${SRCDIR}/meta-wheelme-dev"' >> ${BBLAYERS_CONF}
#  fi
#fi

# Appending these lines to local.conf
#MACHINE ?= "jetson-xavier-nx-devkit-emmc"
#DISTRO_FEATURES = "x11 opengl"
#IMAGE_CLASSES += "image_types_tegra"
#IMAGE_FSTYPES += "tegraflash wic.gz ext4"
#WKS_FILE = "jetson-sdcard.wks"

# PACKAGE_CLASSES = "package_ipk"
# EXTRA_IMAGE_FEATURES += "package-management"
# CONNECTIVITY_CHECK_URIS = "https://google.com"
# DL_DIR = "${POKYROOT}/downloads"
# SSTATE_DIR = "${POKYROOT}/sstate-cache"
# BB_NUMBER_THREADS = '4'
# PARALLEL_MAKE = '-j4'

egrep "^\s*MACHINE\s*\?=\s*\"jetson-xavier-nx-devkit-emmc\"$" ${LOCAL_CONF} &> /dev/null
if [ $? -ne "0" ] ; then
  echo "MACHINE ?= \"jetson-xavier-nx-devkit-emmc\"" >> ${LOCAL_CONF}
fi

egrep "^\s*IMAGE_CLASSES\s*\+=\s*\"image_types_tegra\"$" ${LOCAL_CONF} &> /dev/null
if [ $? -ne "0" ] ; then
  echo "IMAGE_CLASSES += \"image_types_tegra\"" >> ${LOCAL_CONF}
fi

egrep "^\s*IMAGE_FSTYPES\s*\+=\s*\"tegraflash\"$" ${LOCAL_CONF} &> /dev/null
if [ $? -ne "0" ] ; then
  echo "IMAGE_FSTYPES += \"tegraflash\"" >> ${LOCAL_CONF}
fi

grep -E "^[[:space:]]?PACKAGE_CLASSES[[:space:]]?\=[[:space:]]?\"package_ipk\"[[:space:]]?$" ${LOCAL_CONF} &> /dev/null
if [ $? -ne "0" ] ; then
  echo 'PACKAGE_CLASSES = "package_ipk"' >> ${LOCAL_CONF}
fi

grep -E "^[[:space:]]?EXTRA_IMAGE_FEATURES[[:space:]]?\+\=[[:space:]]?\"package-management\"[[:space:]]?$" ${LOCAL_CONF} &> /dev/null
if [ $? -ne "0" ] ; then
  echo 'EXTRA_IMAGE_FEATURES += "package-management"' >> ${LOCAL_CONF}
fi

grep -E "^[[:space:]]?CONNECTIVITY_CHECK_URIS[[:space:]]?\=[[:space:]]?\"https://google.com\"[[:space:]]?$" ${LOCAL_CONF} &> /dev/null
if [ $? -ne "0" ] ; then
  echo 'CONNECTIVITY_CHECK_URIS = "https://google.com"' >> ${LOCAL_CONF}
fi

grep -E "^[[:space:]]?DL_DIR[[:space:]]?\=[[:space:]]?\"downloads\"[[:space:]]?$" ${LOCAL_CONF} &> /dev/null
if [ $? -ne "0" ] ; then
  echo "DL_DIR = \"${POKYROOT}/downloads\"" >> ${LOCAL_CONF}
fi

grep -E "^[[:space:]]?SSTATE_DIR[[:space:]]?\=[[:space:]]?\"sstate-dir\"[[:space:]]?$" ${LOCAL_CONF} &> /dev/null
if [ $? -ne "0" ] ; then
  echo "SSTATE_DIR = \"${POKYROOT}/sstate-dir\"" >> ${LOCAL_CONF}
fi

egrep "^\s*BB_NUMBER_THREADS\s*=\s*\'4\'$" ${LOCAL_CONF} &> /dev/null
if [ $? -ne "0" ] ; then
  echo "BB_NUMBER_THREADS = '4'" >> ${LOCAL_CONF}
fi

egrep "^\s*PARALLEL_MAKE\s*=\s*\'-j4\'" ${LOCAL_CONF} &> /dev/null
if [ $? -ne "0" ] ; then
  echo "PARALLEL_MAKE = '-j4'" >> ${LOCAL_CONF}
fi


#grep -E "^[[:space:]]?RDEPENDS_VULKAN_LOADER_mx8_remove[[:space:]]?\=[[:space:]]?\"vulkan-validationlayers\"[[:space:]]?$" ${LOCAL_CONF}
#if [ $? -ne "0" ] ; then
#  echo "SSTATE_DIR = \"/opt/sstate-cache\"" >> ${LOCAL_CONF}
#
#  echo "RDEPENDS_VULKAN_LOADER_mx8_remove = \"vulkan-validationlayers\"" >> ${LOCAL_CONF}
#fi

# Configure docker SSTATE configuration
#DOCKER_SSTATE_YML="${POKYROOT}/docker-compose.sstate.yml"
#echo "version: '3.3'"                                                   >  ${DOCKER_SSTATE_YML}
#echo "services:"                                                        >> ${DOCKER_SSTATE_YML}
#echo "    poky:"                                                        >> ${DOCKER_SSTATE_YML}
#echo "        volumes:"                                                 >> ${DOCKER_SSTATE_YML}
#echo "            -  ${POKYROOT}/sstate-cache:/opt/sstate-cache"        >> ${DOCKER_SSTATE_YML}
#echo "            -  ${POKYROOT}/downloads:/opt/downloads"              >> ${DOCKER_SSTATE_YML}
#echo "        tty: true"                                                >> ${DOCKER_SSTATE_YML}

# Executing dev build environment setup
#if [ -f "${SETUPENV_DEV}" ]; then
# source "${SETUPENV_DEV}"
#fi
