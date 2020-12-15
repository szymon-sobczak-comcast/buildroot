################################################################################
#
# nghttp2
#
################################################################################

<<<<<<< HEAD
NGHTTP2_VERSION = 1.39.2
NGHTTP2_SITE = https://github.com/nghttp2/nghttp2/releases/download/v$(NGHTTP2_VERSION)
NGHTTP2_LICENSE = MIT
NGHTTP2_LICENSE_FILES = COPYING
NGHTTP2_INSTALL_STAGING = YES
NGHTTP2_DEPENDENCIES = host-pkgconf
NGHTTP2_CONF_OPTS = --enable-lib-only

define NGHTTP2_INSTALL_CLEAN_HOOK
	# Remove fetch-ocsp-response script unused by library
	$(Q)$(RM) -rf $(TARGET_DIR)/usr/share/nghttp2
endef

NGHTTP2_POST_INSTALL_TARGET_HOOKS += NGHTTP2_INSTALL_CLEAN_HOOK

$(eval $(autotools-package))
=======
NGHTTP2_VERSION = 939ad5ddbeeb153c6df23ddfb33b0e9b299708a5
NGHTTP2_SITE = git@github.com:nghttp2/nghttp2.git
NGHTTP2_SITE_METHOD = git
NGHTTP2_LICENSE = MIT
NGHTTP2_INSTALL_STAGING = YES

$(eval $(cmake-package))

>>>>>>> origin/master
