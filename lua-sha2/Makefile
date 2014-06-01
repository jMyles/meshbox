include $(TOPDIR)/rules.mk

PKG_NAME:=lua-sha2
PKG_VERSION:=0.2.0
PKG_RELEASE:=$(PKG_VERSION)

PKG_SOURCE:=sha2-$(PKG_VERSION).zip
PKG_SOURCE_SUBDIR:=sha2-$(PKG_VERSION)
PKG_SOURCE_URL:=https://sha2.googlecode.com/git
PKG_CAT:=unzip
PKG_MD5SUM:=ee59eef03995fb93ed3a5e4acbd1883c

include $(INCLUDE_DIR)/package.mk

define Package/lua-sha2
  SUBMENU:=Lua
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Lua binding for the SHA-256/384/512
  URL:=https://code.google.com/p/sha2/
  DEPENDS:=+lua
endef

define Package/lua-sha2/description
  Lua binding for the SHA-256/384/512 BSD-licensed C implementation by Aaron Gifford
  http://www.aarongifford.com/computers/sha.html
endef

define Build/Configure

endef

define Build/Compile
  CC="$(TARGET_CC)" \
  CFLAGS="$(TARGET_CFLAGS) -I$(PKG_BUILD_DIR) -I$(STAGING_DIR)/usr/include -fPIC -DSHA2_USE_INTTYPES_H -DBYTE_ORDER -DLITTLE_ENDIAN" \
  LIBS="$(TARGET_LIBS)" \
  $(MAKE) -C $(PKG_BUILD_DIR) sha2lib.o sha2.o
endef


define Package/lua-sha2/install
  CC="$(TARGET_CC)" \
  CFLAGS="$(TARGET_CFLAGS) -I$(PKG_BUILD_DIR) -I$(STAGING_DIR)/usr/include -fPIC -DSHA2_USE_INTTYPES_H -DBYTE_ORDER -DLITTLE_ENDIAN" \
  LIBS="$(TARGET_LIBS)" \
  LDFLAGS="$(TARGET_LDFLAGS)" \
	$(TARGET_CC) -shared -o $(PKG_BUILD_DIR)/sha2.so \
  $(PKG_BUILD_DIR)/sha2.o $(PKG_BUILD_DIR)/sha2lib.o

	$(INSTALL_DIR) $(1)/usr/lib/lua/hmac
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/sha2.so $(1)/usr/lib/lua
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/hmac.lua	$(1)/usr/lib/lua
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/hmac/sha2.lua 	$(1)/usr/lib/lua/hmac
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/hmac/md5.lua 	$(1)/usr/lib/lua/hmac
endef

$(eval $(call BuildPackage,lua-sha2))
