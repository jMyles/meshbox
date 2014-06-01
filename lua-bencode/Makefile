include $(TOPDIR)/rules.mk

PKG_NAME:=lua-bencode
PKG_VERSION:=2.1.0
PKG_RELEASE:=$(PKG_VERSION)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE_URL:=https://bitbucket.org/wilhelmy/lua-bencode
PKG_SOURCE_PROTO:=hg
PKG_SOURCE_VERSION:=500243383cb6acbddd3cf12aee6e4667aab53324 # RELEASE-2.1.0 tag

include $(INCLUDE_DIR)/package.mk

define Package/lua-bencode
  SUBMENU:=Lua
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Lua Bencode
  URL:=https://bitbucket.org/wilhelmy/lua-bencode
  DEPENDS:=+lua
endef

define Package/lua-bencode/description
  This is a module for the lua programming language for decoding and encoding
  bencoded data which can be used to read and write torrent files for bittorrent.
endef

define Build/Configure
endef

define Build/Compile
endef


define Package/lua-bencode/install
	$(INSTALL_DIR) $(1)/usr/lib/lua
	$(INSTALL_DATA) $(BUILD_DIR)/bencode/bencode.lua $(1)/usr/lib/lua
endef

$(eval $(call BuildPackage,lua-bencode))
