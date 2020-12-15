################################################################################
#
# gst1-validate
#
################################################################################

GST1_VALIDATE_VERSION = 1.16.2
<<<<<<< HEAD
=======

ifeq ($(BR2_PACKAGE_GSTREAMER1_10),y)
GST1_VALIDATE_VERSION = 1.10.4
endif

ifeq ($(BR2_PACKAGE_GSTREAMER1_14),y)
GST1_VALIDATE_VERSION = 1.14.4
endif

ifeq ($(BR2_PACKAGE_GSTREAMER1_16),y)
GST1_VALIDATE_VERSION = 1.16.2
endif

>>>>>>> origin/master
GST1_VALIDATE_SOURCE = gst-validate-$(GST1_VALIDATE_VERSION).tar.xz
GST1_VALIDATE_SITE = https://gstreamer.freedesktop.org/src/gst-validate
GST1_VALIDATE_LICENSE = LGPL-2.1+
GST1_VALIDATE_LICENSE_FILES = COPYING

GST1_VALIDATE_DEPENDENCIES = \
	gstreamer1 \
	gst1-plugins-base \
	json-glib \
	$(if $(BR2_PACKAGE_CAIRO),cairo)

ifeq ($(BR2_PACKAGE_PYTHON3),y)
GST1_VALIDATE_DEPENDENCIES += host-python3 python3
else
GST1_VALIDATE_DEPENDENCIES += host-python python
endif

GST1_VALIDATE_CONF_OPTS = \
	--disable-introspection \
	--disable-sphinx-doc

$(eval $(autotools-package))
