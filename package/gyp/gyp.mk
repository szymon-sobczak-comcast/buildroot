################################################################################
#
# gyp
#
################################################################################

<<<<<<< HEAD
GYP_VERSION = e87d37d6bce611abed35e854d5ae1a401e9ce04c
=======
GYP_VERSION = 702ac58e477214c635d9b541932e75a95d349352
>>>>>>> origin/master
GYP_SITE_METHOD = git
GYP_SITE = https://chromium.googlesource.com/external/gyp
GYP_INSTALL_STAGING = NO
GYP_SETUP_TYPE = setuptools
GYP_DEPENDENCIES = host-gyp 
HOST_GYP_DEPENDENCIES = host-python host-python-setuptools 

define HOST_GYP_CONFIGURE_CMDS
	(cd $(@D); rm -rf build)
endef

define HOST_GYP_BUILD_CMDS
	$(HOST_MAKE_ENV) PYTHON=$(HOST_DIR)/usr/bin/python2;
<<<<<<< HEAD
	cd $(@D);$(PYTHON) ./setup.py build;
=======
	cd $(@D);$(PYTHON) setup.py build;
>>>>>>> origin/master
endef

define HOST_GYP_INSTALL_CMDS
        $(HOST_MAKE_ENV) PYTHON=$(HOST_DIR)/usr/bin/python2;
<<<<<<< HEAD
        cd $(@D);$(PYTHON) ./setup.py install;
=======
        cd $(@D);$(PYTHON) setup.py install;
>>>>>>> origin/master
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
