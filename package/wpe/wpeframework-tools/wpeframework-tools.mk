################################################################################
#
# wpeframework-tools
#
################################################################################

<<<<<<< HEAD
WPEFRAMEWORK_TOOLS_VERSION = 2dff35e844acbeb728c95ff0f2ea9ed43fd22db9
=======
WPEFRAMEWORK_TOOLS_VERSION = 6492a029c738e7f13d21ddf6fdcb5db38812b229
>>>>>>> origin/master

HOST_WPEFRAMEWORK_TOOLS_SITE = $(call github,rdkcentral,Thunder,$(WPEFRAMEWORK_TOOLS_VERSION))
HOST_WPEFRAMEWORK_TOOLS_INSTALL_STAGING = YES
HOST_WPEFRAMEWORK_TOOLS_INSTALL_TARGET = NO
HOST_WPEFRAMEWORK_TOOLS_DEPENDENCIES = host-cmake host-python3 host-python3-jsonref
HOST_WPEFRAMEWORK_TOOLS_SUBDIR = Tools

$(eval $(host-cmake-package))
