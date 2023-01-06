################################################################################
#
# sdk-rdkva-sagemcom
#
################################################################################

SDK_RDKVA_SAGEMCOM_VERSION = 2496e154cbfde9f80c6bf43f2ccaf58c4c21df2e
SDK_RDKVA_SAGEMCOM_SITE = git@github.com:Metrological/SDK_RDKVA_Sagemcom.git
SDK_RDKVA_SAGEMCOM_SITE_METHOD = git
SDK_RDKVA_SAGEMCOM_INSTALL_STAGING = YES
SDK_RDKVA_SAGEMCOM_INSTALL_TARGET = NO

define SDK_RDKVA_SAGEMCOM_INSTALL_STAGING_CMDS
	cp -r $(@D)/usr/* $(STAGING_DIR)/usr/
endef

#define SDK_RDKVA_SAGEMCOM_INSTALL_TARGET_CMDS
#	cp -r $(@D)/usr/lib/* $(STAGING_DIR)/usr/lib/
#endef

$(eval $(generic-package))
