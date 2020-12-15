################################################################################
#
# kmscube
#
################################################################################

<<<<<<< HEAD
KMSCUBE_VERSION = 4660a7dca6512b6e658759d00cff7d4ad2a2059d
KMSCUBE_SITE = https://gitlab.freedesktop.org/mesa/kmscube/-/archive/$(KMSCUBE_VERSION)
=======
KMSCUBE_VERSION = 76bb57d539cb43d267e561024c34e031bf351e04
KMSCUBE_SITE = https://cgit.freedesktop.org/mesa/kmscube/snapshot
>>>>>>> origin/master
KMSCUBE_LICENSE = MIT
KMSCUBE_DEPENDENCIES = host-pkgconf mesa3d libdrm

$(eval $(meson-package))
