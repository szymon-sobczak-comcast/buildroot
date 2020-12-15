################################################################################
#
# nanomsg
#
################################################################################

<<<<<<< HEAD
NANOMSG_VERSION = 1.1.5
NANOMSG_SITE = $(call github,nanomsg,nanomsg,$(NANOMSG_VERSION))
NANOMSG_INSTALL_STAGING = YES
NANOMSG_LICENSE = MIT
NANOMSG_LICENSE_FILES = COPYING
NANOMSG_CONF_OPTS = -DNN_ENABLE_DOC=OFF -DNN_TESTS=OFF

ifeq ($(BR2_STATIC_LIBS),y)
NANOMSG_CONF_OPTS += -DNN_STATIC_LIB=ON
endif

ifeq ($(BR2_PACKAGE_NANOMSG_TOOLS),y)
NANOMSG_CONF_OPTS += -DNN_TOOLS=ON
else
NANOMSG_CONF_OPTS += -DNN_TOOLS=OFF
endif
=======
NANOMSG_VERSION = 0c1aa2b288f6b167dbafe7e29c20e6fc7e71c000
NANOMSG_SITE_METHOD = git
NANOMSG_SITE = git://github.com/nanomsg/nanomsg.git
NANOMSG_INSTALL_STAGING = YES
>>>>>>> origin/master

$(eval $(cmake-package))
