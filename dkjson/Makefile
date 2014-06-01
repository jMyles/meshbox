include $(TOPDIR)/rules.mk

PKG_NAME:=dkjson
PKG_VERSION:=2.4.0
PKG_RELEASE:=$(PKG_VERSION)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE_URL:=https://github.com/LuaDist/dkjson.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=7ba6b81eb2c9a5ef0748b9a0399d8dc25c637202 # 2.4 tag

include $(INCLUDE_DIR)/package.mk

define Package/dkjson
  SUBMENU:=Lua
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=DKJSON
  URL:=http://dkolf.de/src/dkjson-lua.fsl/home
  DEPENDS:=+lua
endef

define Package/dkjson/description
  This is a JSON module written in Lua. It supports UTF-8.
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/dkjson/install
	$(INSTALL_DIR) $(1)/usr/lib/lua
	$(INSTALL_BIN) $(BUILD_DIR)/dkjson/dkjson.lua $(1)/usr/lib/lua/
endef

$(eval $(call BuildPackage,dkjson))
