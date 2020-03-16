################################################################################
#
# crun
#
################################################################################

CRUN_VERSION = 0.13
CRUN_SITE = https://github.com/containers/crun/releases/download/$(CRUN_VERSION)
CRUN_LICENSE = GPLv2+
CRUN_LICENSE_FILES = COPYING
CRUN_INSTALL_STAGING = YES
CRUN_DEPENDENCIES = host-python3 yajl libseccomp

#CRUN_AUTORECONF = YES
CRUN_CONF_OPTS = --disable-systemd --disable-shared
#CRUN_AUTORECONF_ENV = PYTHON=python3
CRUN_CONF_ENV = PYTHON=python3

$(eval $(autotools-package))
