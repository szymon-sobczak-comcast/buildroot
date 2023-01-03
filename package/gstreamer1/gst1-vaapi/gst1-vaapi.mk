################################################################################
#
# gst1-vaapi
#
################################################################################

GST1_VAAPI_VERSION = 1.16.2

ifeq ($(BR2_PACKAGE_GSTREAMER1_16),y)
GST1_VAAPI_VERSION = 1.16.2
endif

ifeq ($(BR2_PACKAGE_GSTREAMER1_18),y)
GST1_VAAPI_VERSION = 1.18.6
endif

GST1_VAAPI_SITE = https://gstreamer.freedesktop.org/src/gstreamer-vaapi
GST1_VAAPI_SOURCE = gstreamer-vaapi-$(GST1_VAAPI_VERSION).tar.xz
GST1_VAAPI_LICENSE = LGPL-2.1+
GST1_VAAPI_LICENSE_FILES = COPYING.LIB

GST1_VAAPI_DEPENDENCIES += \
	gstreamer1 \
	gst1-plugins-base \
	gst1-plugins-bad \
	libva \
	libdrm

ifeq ($(BR2_PACKAGE_GSTREAMER1_16),y)
# 1.16.2, build with autotools
GST1_VAAPI_CONF_OPTS += \
	--disable-x11 \
	--disable-glx \
	--disable-wayland \
	--disable-egl \
	--disable-gtk-doc-html

ifeq ($(BR2_PACKAGE_GST1_VAAPI_ENCODERS),y)
GST1_VAAPI_CONF_OPTS += --enable-encoders
else
GST1_VAAPI_CONF_OPTS += --disable-encoders
endif

GST1_VAAPI_CFLAGS = $(TARGET_CFLAGS) $(GSTREAMER1_EXTRA_COMPILER_OPTIONS)
$(eval $(autotools-package))
else
# 1.18.6 or above, build with meson
GST1_VAAPI_CONF_OPTS += \
	-Dwith_drm=yes \
	-Dwith_x11=no \
	-Dwith_glx=no \
	-Dwith_wayland=no \
	-Dwith_egl=no \
	-Dexamples=disabled \
	-Dtests=disabled \
	-Ddoc=disabled

ifeq ($(BR2_PACKAGE_GST1_VAAPI_ENCODERS),y)
GST1_VAAPI_CONF_OPTS += -Dwith_encoders=yes
else
GST1_VAAPI_CONF_OPTS += -Dwith_encoders=no
endif

$(eval $(meson-package))
endif

