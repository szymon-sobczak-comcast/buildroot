################################################################################
#
# disney-libopenssl
#
################################################################################

DISNEY_LIBOPENSSL_VERSION = 1.0.2d
DISNEY_LIBOPENSSL_SITE = http://www.openssl.org/source
DISNEY_LIBOPENSSL_SOURCE = openssl-$(DISNEY_LIBOPENSSL_VERSION).tar.gz
DISNEY_LIBOPENSSL_LICENSE = OpenSSL or SSLeay
DISNEY_LIBOPENSSL_LICENSE_FILES = LICENSE
DISNEY_LIBOPENSSL_INSTALL_STAGING = YES
DISNEY_LIBOPENSSL_DEPENDENCIES = zlib
DISNEY_LIBOPENSSL_TARGET_ARCH = generic32
DISNEY_LIBOPENSSL_CFLAGS = $(TARGET_CFLAGS)
DISNEY_LIBOPENSSL_PATCH = \
	https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-libs/openssl/files/openssl-1.0.2d-parallel-build.patch?id=c8abcbe8de5d3b6cdd68c162f398c011ff6e2d9d \
	https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-libs/openssl/files/openssl-1.0.2a-parallel-obj-headers.patch?id=c8abcbe8de5d3b6cdd68c162f398c011ff6e2d9d \
	https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-libs/openssl/files/openssl-1.0.2a-parallel-install-dirs.patch?id=c8abcbe8de5d3b6cdd68c162f398c011ff6e2d9d \
	https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-libs/openssl/files/openssl-1.0.2a-parallel-symlinking.patch?id=c8abcbe8de5d3b6cdd68c162f398c011ff6e2d9d

DISNEY_LIBOPENSSL_SO_VERSION = 1.0.0

# relocation truncated to fit: R_68K_GOT16O
ifeq ($(BR2_m68k_cf),y)
DISNEY_LIBOPENSSL_CFLAGS += -mxgot
endif

ifeq ($(BR2_USE_MMU),)
DISNEY_LIBOPENSSL_CFLAGS += -DHAVE_FORK=0
endif

# Some architectures are optimized in OpenSSL
# Doesn't work for thumb-only (Cortex-M?)
# ifeq ($(BR2_ARM_CPU_HAS_ARM),y)
# DISNEY_LIBOPENSSL_TARGET_ARCH = armv4
# endif
ifeq ($(ARCH),aarch64)
DISNEY_LIBOPENSSL_TARGET_ARCH = aarch64
endif
ifeq ($(ARCH),powerpc)
# 4xx cores seem to have trouble with openssl's ASM optimizations
ifeq ($(BR2_powerpc_401)$(BR2_powerpc_403)$(BR2_powerpc_405)$(BR2_powerpc_405fp)$(BR2_powerpc_440)$(BR2_powerpc_440fp),)
DISNEY_LIBOPENSSL_TARGET_ARCH = ppc
endif
endif
ifeq ($(ARCH),powerpc64)
DISNEY_LIBOPENSSL_TARGET_ARCH = ppc64
endif
ifeq ($(ARCH),powerpc64le)
DISNEY_LIBOPENSSL_TARGET_ARCH = ppc64le
endif
ifeq ($(ARCH),x86_64)
DISNEY_LIBOPENSSL_TARGET_ARCH = x86_64
endif

define DISNEY_LIBOPENSSL_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		./Configure \
			linux-$(DISNEY_LIBOPENSSL_TARGET_ARCH) \
			--prefix=/usr/disney-ssl \
			--openssldir=/etc/ssl \
			--libdir=/lib \
			$(if $(BR2_TOOLCHAIN_HAS_THREADS),threads,no-threads) \
			$(if $(BR2_STATIC_LIBS),no-shared,shared) \
			no-rc5 \
			enable-camellia \
			enable-mdc2 \
			enable-tlsext \
			$(if $(BR2_STATIC_LIBS),zlib,zlib-dynamic) \
			$(if $(BR2_STATIC_LIBS),no-dso) \
	)
	$(SED) "s#-march=[-a-z0-9] ##" -e "s#-mcpu=[-a-z0-9] ##g" $(@D)/Makefile
	$(SED) "s#-O[0-9]#$(DISNEY_LIBOPENSSL_CFLAGS)#" $(@D)/Makefile
	$(SED) "s# build_tests##" $(@D)/Makefile
endef

define DISNEY_LIBOPENSSL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define DISNEY_LIBOPENSSL_INSTALL_STAGING_CMDS
	$(STAGING_MAKE_ENV) $(MAKE) -C $(@D) INSTALL_PREFIX=$(STAGING_DIR) install
        for i in $(addprefix $(STAGING_DIR)/usr/disney-ssl/lib/,libcrypto.so.* libssl.so.*); \
        do chmod +w $$i; done
        cp $(STAGING_DIR)/usr/disney-ssl/lib/lib*.so.$(DISNEY_LIBOPENSSL_SO_VERSION) $(STAGING_DIR)/usr/lib
endef

define DISNEY_LIBOPENSSL_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) INSTALL_PREFIX=$(TARGET_DIR) install
        for i in $(addprefix $(TARGET_DIR)/usr/disney-ssl/lib/,libcrypto.so.* libssl.so.*); \
        do chmod +w $$i; done
        cp $(TARGET_DIR)/usr/disney-ssl/lib/lib*.so.$(DISNEY_LIBOPENSSL_SO_VERSION) $(TARGET_DIR)/usr/lib
        rm -rf $(TARGET_DIR)/usr/disney-ssl
endef

$(eval $(generic-package))
