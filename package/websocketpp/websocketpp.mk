################################################################################
#
<<<<<<< HEAD
# websocketpp
=======
# websocketpp / websocket++
>>>>>>> origin/master
#
################################################################################

WEBSOCKETPP_VERSION = 0.8.1
<<<<<<< HEAD
WEBSOCKETPP_SITE = $(call github,zaphoyd,websocketpp,$(WEBSOCKETPP_VERSION))
WEBSOCKETPP_LICENSE = BSD-3c, MIT, Zlib
WEBSOCKETPP_LICENSE_FILES = COPYING
WEBSOCKETPP_INSTALL_STAGING = YES
# Only installs headers
WEBSOCKETPP_INSTALL_TARGET = NO

$(eval $(cmake-package))
=======
WEBSOCKETPP_SITE =  $(call github,zaphoyd,websocketpp,$(WEBSOCKETPP_VERSION))
WEBSOCKETPP_LICENSE = BSD-3c
WEBSOCKETPP_LICENSE_FILES = COPYING
WEBSOCKETPP_INSTALL_STAGING = YES
WEBSOCKETPP_INSTALL_TARGET = NO
WEBSOCKETPP_DEPENDENCIES = host-cmake

$(eval $(cmake-package))

>>>>>>> origin/master
