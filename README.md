# Wheel.me Yocto manifest

This repository contains the manifest files for the Wheel.me Embedded Yocto

## Setting up Wheel.me Yocto environment

Creating the poky folder and getting repo tool

```sh
mkdir -p poky-wheelme/.repo
cd poky-wheelme/.repo
git clone https://gerrit.googlesource.com/git-repo repo
cd repo
export PATH=$PATH:$PWD
cd ../..
```
retrieve source using repo command
```sh
repo init -u git@gitlab.com:wheelme-devops/wheelme-repo.git -b gatesgarth -m default.xml
```
if no problems reported, get the sources using repo sync command, with -j and number of parallel jobs which can be run on your computer

```sh
repo sync -j4
```
configure the build environment running this command
```sh
MACHINE=imx8mp-var-dart DISTRO=fsl-imx-xwayland source wheelme-setenv.sh -b build_xwayland
```
it should move you to the *build_xwayland* folder.

This step step is temproary added, will be removed in the future, update bblayers.conf and local.conf


before making a build we need to install docker on a build machine, follow these 
[instructions](https://gitlab.com/wheelme-devops/wheelme-docker/-/blob/master/README.md)

the required containers can be found here within the poky-wheelme tree
```sh
cd poky-wheelme/sources/meta-wheelme/docker
```

The wheelme-setenv.sh will automatically create poky-wheelme/docker-compose.sstate.yml which will be read by the
container. Now you can start container and run a build in a container

```sh
cd poky-wheelme
MACHINE=imx8mp-var-dart DISTRO=fsl-imx-xwayland source wheelme-setenv.sh -b build_xwayland
bitbake fsl-image-gui
```

once the build's finished run this command from [these instructions](https://variwiki.com/index.php?title=Yocto_Build_Release&release=RELEASE_ZEUS_V3.0_DART-MX8M-PLUS) to make booting sd card

```sh
sudo MACHINE=imx8mp-var-dart sources/meta-variscite-imx/scripts/var_mk_yocto_sdcard/var-create-yocto-sdcard.sh -a /dev/sdX
```
where /dev/sdX - is sd card device name, for example in my system it's */dev/sde*.

**IMPORTANT!**
The var-create-yocto-sdcard.sh has a bug change the TEMP_DIR variable to
```sh
TEMP_DIR=/tmp/var_tmp
```
To make a boot from eMMC you need to follow [these instructions](https://variwiki.com/index.php?title=Yocto_NAND_Flash_Burning&release=RELEASE_ZEUS_V3.0_DART-MX8M-PLUS)

# References
1 [Variscite DART-MX8M-PLUS - Yocto Zeus 3.0](https://variwiki.com/index.php?title=Yocto_Build_Release&release=RELEASE_ZEUS_V3.0_DART-MX8M-PLUS)

2 [IMX-MX8M-PLUS PRM](https://www.nxp.com/docs/en/reference-manual/IMX8MPRM.pdf)

3 [SOM DART-MX8M-PLUS Datasheet](https://www.variscite.com/wp-content/uploads/2020/10/DART-MX8M-PLUS_Datasheet.pdf)
