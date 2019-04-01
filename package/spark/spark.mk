################################################################################
#
# spark
#
################################################################################
SPARK_VERSION = dac0e9fecc26480a9fa1e53781244c9b9f9aa16c
SPARK_SITE_METHOD = git
SPARK_SITE = git://github.com/HaseenaSainul/pxCore
SPARK_INSTALL_STAGING = YES

SPARK_DEPENDENCIES = openssl freetype westeros util-linux libpng libcurl rtremote rtcore pxcore-libnode

export HOSTNAME = "raspberrypi"

SPARK_CONF_OPTS += \
    -DBUILD_WITH_WAYLAND=ON \
    -DBUILD_WITH_WESTEROS=ON \
    -DBUILD_WITH_TEXTURE_USAGE_MONITORING=ON \
    -DPXCORE_COMPILE_WARNINGS_AS_ERRORS=OFF \
    -DPXSCENE_COMPILE_WARNINGS_AS_ERRORS=OFF \
    -DCMAKE_SKIP_RPATH=ON \
    -DPXCORE_WAYLAND_EGL=ON \
    -DBUILD_PXSCENE_WAYLAND_EGL=ON \
    -DPXCORE_MATRIX_HELPERS=OFF \
    -DBUILD_PXWAYLAND_SHARED_LIB=OFF \
    -DBUILD_PXWAYLAND_STATIC_LIB=OFF \
    -DPXCORE_ESSOS=ON \
    -DBUILD_PXSCENE_ESSOS=ON \
    -DPREFER_SYSTEM_LIBRARIES=ON \
    -DDISABLE_TURBO_JPEG=ON \
    -DDISABLE_DEBUG_MODE=ON \
    -DSPARK_BACKGROUND_TEXTURE_CREATION=ON \
    -DSPARK_ENABLE_LRU_TEXTURE_EJECTION=OFF \
    -DHOSTNAME=raspberrypi \
    -DBUILD_RTCORE_LIBS=OFF \
    -DSUPPORT_DUKTAPE=OFF \
    -DBUILD_DUKTAPE=ON

ifeq ($(BR2_PACKAGE_SPARK_LIB), y)

SPARK_CONF_OPTS += \
    -DBUILD_PXSCENE_APP=OFF \
    -DBUILD_PXSCENE_STATIC_LIB=OFF \
    -DBUILD_PXSCENE_SHARED_LIB=ON
else

SPARK_CONF_OPTS += \
    -DBUILD_OPTIMUS_STATIC_LIB=ON \
    -DBUILD_PXSCENE_APP_WITH_PXSCENE_LIB=ON \
    -DBUILD_RTREMOTE_LIBS=ON
endif


define SPARK_INSTALL_LIBS
    $(INSTALL) -m 755 $(@D)/build/egl/libpxCore.so $(1)/usr/lib/
#    $(INSTALL) -m 755 $(@D)/examples/pxScene2d/src/liboptimus.so $(1)/usr/lib/
endef

define SPARK_INSTALL_DEPS
    mkdir -p $(TARGET_DIR)/root/spark
    cp -ar $(@D)/examples/pxScene2d/src/node_modules $(TARGET_DIR)/root/spark/
    $(INSTALL) -m 755 $(@D)/examples/pxScene2d/src/*.js $(TARGET_DIR)/root/spark/
    $(INSTALL) -m 755 $(@D)/examples/pxScene2d/src/*.json $(TARGET_DIR)/root/spark/
    $(INSTALL) -m 755 $(@D)/examples/pxScene2d/src/*.ttf $(TARGET_DIR)/root/spark/
    $(INSTALL) -m 755 $(@D)/examples/pxScene2d/src/sparkpermissions.conf $(TARGET_DIR)/root/spark/
    $(INSTALL) -m 755 $(@D)/examples/pxScene2d/src/waylandregistry.conf $(TARGET_DIR)/root/spark/
    cp -ar $(@D)/examples/pxScene2d/src/rcvrcore $(TARGET_DIR)/root/spark/
    cp -ar $(@D)/examples/pxScene2d/src/browser $(TARGET_DIR)/root/spark/
    cp -ar $(@D)/examples/pxScene2d/src/optimus $(TARGET_DIR)/root/spark/
    cp -ar $(@D)/examples/pxScene2d/src/duk_modules $(TARGET_DIR)/root/spark/
    cp -ar $(@D)/examples/pxScene2d/src/v8_modules $(TARGET_DIR)/root/spark/
    cp -ar $(@D)/examples/pxScene2d/src/rasterizer $(TARGET_DIR)/root/spark/
endef

ifeq ($(BR2_PACKAGE_SPARK_LIB), y)
define SPARK_INSTALL_STAGING_CMDS
    $(call SPARK_INSTALL_LIBS, $(STAGING_DIR))
    mkdir -p $(STAGING_DIR)/usr/include/spark
    cp -ar $(@D)/src/*.h $(STAGING_DIR)/usr/include/spark/
    cp -ar $(@D)/examples/pxScene2d/src/*.h $(STAGING_DIR)/usr/include/spark/
    mkdir -p $(STAGING_DIR)/usr/include/spark/wayland_egl
    cp -ar $(@D)/src/wayland_egl/*.h $(STAGING_DIR)/usr/include/spark/wayland_egl/
    $(INSTALL) -D package/spark/Spark.pc $(STAGING_DIR)/usr/lib/pkgconfig/Spark.pc
    $(INSTALL) -m 755 $(@D)/examples/pxScene2d/src/libSpark.so $(STAGING_DIR)/usr/lib
endef

define SPARK_INSTALL_TARGET_CMDS
    $(SPARK_INSTALL_DEPS)
    $(call SPARK_INSTALL_LIBS, $(TARGET_DIR))
    $(INSTALL) -m 755 $(@D)/examples/pxScene2d/src/libSpark.so $(TARGET_DIR)/usr/lib
endef

else
define SPARK_INSTALL_STAGING_CMDS
    $(call SPARK_INSTALL_LIBS, $(STAGING_DIR))
endef

define SPARK_INSTALL_TARGET_CMDS
    $(SPARK_INSTALL_DEPS)
    $(call SPARK_INSTALL_LIBS, $(TARGET_DIR))
    $(INSTALL) -m 755 $(@D)/examples/pxScene2d/src/Spark $(TARGET_DIR)/usr/bin
endef
endif
$(eval $(cmake-package))