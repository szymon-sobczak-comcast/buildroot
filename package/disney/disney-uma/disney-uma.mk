################################################################################
#
# Disney+ player
#
################################################################################

DISNEY_UMA_VERSION = 243b6a6a75b2a6690fc58563ebbe7be902f33e06
DISNEY_UMA_SITE = git@github.com:Metrological/disneyplus-uma.git
DISNEY_UMA_SITE_METHOD = git
DISNEY_UMA_LICENSE = PROPRIETARY
DISNEY_UMA_INSTALL_STAGING = YES
DISNEY_UMA_DEPENDENCIES = libopenssl

_DISNEY_UMA_PLATFORM = *44*

define _DISNEY_UMA_INSTALL
       @echo "Installing player library"
       cp -R $(@D)/prebuilt-libs/$(_DISNEY_UMA_PLATFORM)/unstripped/$(_DISNEY_BUILD_TYPE)/*.so $(1)/usr/lib/
endef

define DISNEY_UMA_INSTALL_STAGING_CMDS
       $(call _DISNEY_UMA_INSTALL, $(STAGING_DIR))
endef

define DISNEY_UMA_INSTALL_TARGET_CMDS
       $(call _DISNEY_UMA_INSTALL, $(TARGET_DIR))
endef

$(eval $(generic-package))