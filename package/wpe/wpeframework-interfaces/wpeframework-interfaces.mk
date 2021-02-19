################################################################################
#
# wpeframework-interfaces
#
################################################################################

WPEFRAMEWORK_INTERFACES_VERSION = cc38a85704f5a1f9ece8abb38b572a62b3c03e1a
WPEFRAMEWORK_INTERFACES_SITE = $(call github,rdkcentral,ThunderInterfaces,$(WPEFRAMEWORK_INTERFACES_VERSION))
WPEFRAMEWORK_INTERFACES_INSTALL_STAGING = YES
WPEFRAMEWORK_INTERFACES_DEPENDENCIES = wpeframework

WPEFRAMEWORK_INTERFACES_OPKG_NAME = "wpeframework-interfaces"
WPEFRAMEWORK_INTERFACES_OPKG_VERSION = "1.0.0"
WPEFRAMEWORK_INTERFACES_OPKG_ARCHITECTURE = "${BR2_ARCH}"
WPEFRAMEWORK_INTERFACES_OPKG_MAINTAINER = "Metrological"
WPEFRAMEWORK_INTERFACES_OPKG_DESCRIPTION = "WPEFramework interfaces"

WPEFRAMEWORK_INTERFACES_CONF_OPTS += -DBUILD_REFERENCE=${WPEFRAMEWORK_INTERFACES_VERSION}

ifeq ($(BR2_CMAKE_HOST_DEPENDENCY),)
WPEFRAMEWORK_INTERFACES_CONF_OPTS += \
       -DCMAKE_MODULE_PATH=$(HOST_DIR)/share/cmake/Modules
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_BUILD_TYPE_DEBUG),y)
        WPEFRAMEWORK_INTERFACES_CONF_OPTS += -DBUILD_TYPE=Debug
else ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_BUILD_TYPE_DEBUG_OPTIMIZED),y)
        WPEFRAMEWORK_INTERFACES_CONF_OPTS += -DBUILD_TYPE=DebugOptimized
else ifeq ($( BR2_PACKAGE_WPEFRAMEWORK_BUILD_TYPE_RELEASE_WITH_SYMBOLS),y)
        WPEFRAMEWORK_INTERFACES_CONF_OPTS += -DBUILD_TYPE=ReleaseSymbols
else ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_BUILD_TYPE_RELEASE),y)
        WPEFRAMEWORK_INTERFACES_CONF_OPTS += -DBUILD_TYPE=Release
else ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_BUILD_TYPE_PRODUCTION),y)
        WPEFRAMEWORK_INTERFACES_CONF_OPTS += -DBUILD_TYPE=Production
endif

$(eval $(cmake-package))
