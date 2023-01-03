################################################################################
#
# gstreamer1-editing-services
#
################################################################################

GSTREAMER1_EDITING_SERVICES_VERSION = 1.16.2

ifeq ($(BR2_PACKAGE_GSTREAMER1_16),y)
GSTREAMER1_EDITING_SERVICES_VERSION = 1.16.2
GSTREAMER1_EDITING_SERVICES_SOURCE = gstreamer-editing-services-$(GSTREAMER1_EDITING_SERVICES_VERSION).tar.xz
endif

ifeq ($(BR2_PACKAGE_GSTREAMER1_18),y)
GSTREAMER1_EDITING_SERVICES_VERSION = 1.18.6
GSTREAMER1_EDITING_SERVICES_SOURCE = gst-editing-services-$(GSTREAMER1_EDITING_SERVICES_VERSION).tar.xz
endif

GSTREAMER1_EDITING_SERVICES_SITE = http://gstreamer.freedesktop.org/src/gstreamer-editing-services
GSTREAMER1_EDITING_SERVICES_LICENSE = LGPL-2.0+
GSTREAMER1_EDITING_SERVICES_LICENSE_FILES = COPYING COPYING.LIB
GSTREAMER1_EDITING_SERVICES_INSTALL_STAGING = YES
GSTREAMER1_EDITING_SERVICES_DEPENDENCIES = \
	host-pkgconf \
	gstreamer1 \
	gst1-plugins-base \
	gst1-plugins-good \
	$(if $(BR2_PACKAGE_GST1_VALIDATE),gst1-validate) \
	libxml2

ifeq ($(BR2_PACKAGE_GSTREAMER1_16),y)
# 1.16.2, build with autotools
GSTREAMER1_EDITING_SERVICES_CONF_OPTS = --disable-benchmarks

GSTREAMER1_EDITING_SERVICES_CFLAGS = $(TARGET_CFLAGS) $(GSTREAMER1_EXTRA_COMPILER_OPTIONS)

# examples need GTK2/3 with X11 backend
ifneq ($(BR2_PACKAGE_LIBGTK2)$(BR2_PACKAGE_LIBGTK3_X11),)
GSTREAMER1_EDITING_SERVICES_CONF_OPTS += --enable-examples

ifeq ($(BR2_PACKAGE_LIBGTK2),y)
GSTREAMER1_EDITING_SERVICES_CONF_OPTS += --with-gtk=2.0
GSTREAMER1_EDITING_SERVICES_DEPENDENCIES += libgtk2
else
GSTREAMER1_EDITING_SERVICES_CONF_OPTS += --with-gtk=3.0
GSTREAMER1_EDITING_SERVICES_DEPENDENCIES += libgtk3
endif

else
GSTREAMER1_EDITING_SERVICES_CONF_OPTS += --disable-examples
endif

$(eval $(autotools-package))
else
# 1.18.6 or above, build with meson
GSTREAMER1_EDITING_SERVICES_CONF_OPTS = \
	-Ddoc=disabled \
	-Dexamples=disabled \
	-Dintrospection=disabled \
	-Dtests=disabled \
	-Dtools=enabled \
	-Dbash-completion=disabled \
	-Dxptv=disabled \
	-Dpython=disabled

ifeq ($(BR2_PACKAGE_GST1_VALIDATE),y)
GSTREAMER1_EDITING_SERVICES_CONF_OPTS += -Dvalidate=enabled
else
GSTREAMER1_EDITING_SERVICES_CONF_OPTS += -Dvalidate=disabled
endif

$(eval $(meson-package))
endif
