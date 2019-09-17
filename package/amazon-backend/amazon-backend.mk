################################################################################
#
# amazon-backend
#
################################################################################

AMAZON_BACKEND_VERSION = 35ad8f8fb813748edc575549d296c7b9bb7e344a
AMAZON_BACKEND_SITE = git@github.com:Metrological/amazon-backend.git
AMAZON_BACKEND_SITE_METHOD = git
AMAZON_BACKEND_DEPENDENCIES = 
AMAZON_BACKEND_LICENSE = PROPRIETARY
AMAZON_BACKEND_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_GSTREAMER1),y)
AMAZON_BACKEND_DEPENDENCIES += gstreamer1 gst1-plugins-base gst1-plugins-good gst1-plugins-bad
endif

NEXUS_CFLAGS=$(shell cat ${STAGING_DIR}/usr/include/platform_app.inc | grep NEXUS_CFLAGS | cut -d' ' -f3- | awk -F "-std=c89" '{print $$1 $$2}')
NEXUS_LDFLAGS=$(shell cat ${STAGING_DIR}/usr/include/platform_app.inc | grep NEXUS_LDFLAGS | cut -d' ' -f3-)
NEXUS_CLIENT_LD_LIBRARIES=$(shell cat ${STAGING_DIR}/usr/include/platform_app.inc | grep NEXUS_CLIENT_LD_LIBRARIES | cut -d' ' -f4-)

AMAZON_BACKEND_OPTIONS = \
	CXX="$(TARGET_CXX)" \
	LD="$(TARGET_LD)" \
	AR="$(TARGET_AR)" \
	AS="$(TARGET_AS)" \
	RANLIB="$(TARGET_RANLIB)" \
	TARGET_ROOT="$(STAGING_DIR)/usr" \
	NEXUS_CFLAGS="${NEXUS_CFLAGS}" \
	

$(eval $(cmake-package))
 
