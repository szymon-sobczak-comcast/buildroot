################################################################################
#
# This file contains the download helpers for the various package
# infrastructures. It is used to handle downloads from HTTP servers,
# FTP servers, Git repositories, Subversion repositories, Mercurial
# repositories, Bazaar repositories, and SCP servers.
#
################################################################################

# Download method commands
export WGET := $(call qstrip,$(BR2_WGET))
export SVN := $(call qstrip,$(BR2_SVN))
export CVS := $(call qstrip,$(BR2_CVS))
export BZR := $(call qstrip,$(BR2_BZR))
export GIT := $(call qstrip,$(BR2_GIT))
export HG := $(call qstrip,$(BR2_HG))
export SCP := $(call qstrip,$(BR2_SCP))
export LOCALFILES := $(call qstrip,$(BR2_LOCALFILES))

DL_WRAPPER = support/download/dl-wrapper

# DL_DIR may have been set already from the environment
ifeq ($(origin DL_DIR),undefined)
DL_DIR ?= $(call qstrip,$(BR2_DL_DIR))
ifeq ($(DL_DIR),)
DL_DIR := $(TOPDIR)/dl
endif
else
# Restore the BR2_DL_DIR that was overridden by the .config file
BR2_DL_DIR = $(DL_DIR)
endif

# ensure it exists and a absolute path, derefrecing symlinks
DL_DIR := $(shell mkdir -p $(DL_DIR) && cd $(DL_DIR) >/dev/null && pwd -P)

#
# URI scheme helper functions
# Example URIs:
# * http://www.example.com/dir/file
# * scp://www.example.com:dir/file (with domainseparator :)
#
# geturischeme: http
geturischeme = $(firstword $(subst ://, ,$(call qstrip,$(1))))
# getschemeplusuri: git|parameter+http://example.com
getschemeplusuri = $(call geturischeme,$(1))$(if $(2),\|$(2))+$(1)
# stripurischeme: www.example.com/dir/file
stripurischeme = $(lastword $(subst ://, ,$(call qstrip,$(1))))
# domain: www.example.com
domain = $(firstword $(subst $(call domainseparator,$(2)), ,$(call stripurischeme,$(1))))
# notdomain: dir/file
notdomain = $(patsubst $(call domain,$(1),$(2))$(call domainseparator,$(2))%,%,$(call stripurischeme,$(1)))
#
# default domainseparator is /, specify alternative value as first argument
domainseparator = $(if $(1),$(1),/)

# github(user,package,version): returns site of GitHub repository
github = https://github.com/$(1)/$(2)/archive/$(3)

# Expressly do not check hashes for those files
# Exported variables default to immediately expanded in some versions of
# make, but we need it to be recursively-epxanded, so explicitly assign it.
export BR_NO_CHECK_HASH_FOR =

################################################################################
# DOWNLOAD_URIS - List the candidates URIs where to get the package from:
# 1) BR2_PRIMARY_SITE if enabled
# 2) Download site, unless BR2_PRIMARY_SITE_ONLY is set
# 3) BR2_BACKUP_SITE if enabled, unless BR2_PRIMARY_SITE_ONLY is set
#
# Argument 1 is the source location
# Argument 2 is the upper-case package name
#
################################################################################

<<<<<<< HEAD
ifneq ($(call qstrip,$(BR2_PRIMARY_SITE)),)
DOWNLOAD_URIS += \
	$(call getschemeplusuri,$(call qstrip,$(BR2_PRIMARY_SITE)/$($(2)_DL_SUBDIR)),urlencode) \
	$(call getschemeplusuri,$(call qstrip,$(BR2_PRIMARY_SITE)),urlencode)
endif
=======
define DOWNLOAD_GIT
	$(EXTRA_ENV) $(DL_WRAPPER) -b git \
		-o $(DL_DIR)/$($(PKG)_SOURCE) \
		$(if $($(PKG)_GIT_SUBMODULES),-r) \
		$(QUIET) \
		-- \
		$($(PKG)_SITE) \
		$($(PKG)_DL_VERSION) \
		$($(PKG)_RAW_BASE_NAME) \
		$($(PKG)_DL_OPTS)
endef

# TODO: improve to check that the given PKG_DL_VERSION exists on the remote
# repository
define SOURCE_CHECK_GIT
	$(GIT) ls-remote --heads $($(PKG)_SITE) > /dev/null
endef

define DOWNLOAD_BZR
	$(EXTRA_ENV) $(DL_WRAPPER) -b bzr \
		-o $(DL_DIR)/$($(PKG)_SOURCE) \
		$(QUIET) \
		-- \
		$($(PKG)_SITE) \
		$($(PKG)_DL_VERSION) \
		$($(PKG)_RAW_BASE_NAME) \
		$($(PKG)_DL_OPTS)
endef

define SOURCE_CHECK_BZR
	$(BZR) ls --quiet $($(PKG)_SITE) > /dev/null
endef

define DOWNLOAD_CVS
	$(EXTRA_ENV) $(DL_WRAPPER) -b cvs \
		-o $(DL_DIR)/$($(PKG)_SOURCE) \
		$(QUIET) \
		-- \
		$(call stripurischeme,$(call qstrip,$($(PKG)_SITE))) \
		$($(PKG)_DL_VERSION) \
		$($(PKG)_RAWNAME) \
		$($(PKG)_RAW_BASE_NAME) \
		$($(PKG)_DL_OPTS)
endef

# Not all CVS servers support ls/rls, use login to see if we can connect
define SOURCE_CHECK_CVS
	$(CVS) -d:pserver:anonymous:@$(call stripurischeme,$(call qstrip,$($(PKG)_SITE))) login
endef

define DOWNLOAD_SVN
	$(EXTRA_ENV) $(DL_WRAPPER) -b svn \
		-o $(DL_DIR)/$($(PKG)_SOURCE) \
		$(QUIET) \
		-- \
		$($(PKG)_SITE) \
		$($(PKG)_DL_VERSION) \
		$($(PKG)_RAW_BASE_NAME) \
		$($(PKG)_DL_OPTS)
endef

define SOURCE_CHECK_SVN
	$(SVN) ls $($(PKG)_SITE)@$($(PKG)_DL_VERSION) > /dev/null
endef

# SCP URIs should be of the form scp://[user@]host:filepath
# Note that filepath is relative to the user's home directory, so you may want
# to prepend the path with a slash: scp://[user@]host:/absolutepath
define DOWNLOAD_SCP
	$(EXTRA_ENV) $(DL_WRAPPER) -b scp \
		-o $(DL_DIR)/$(2) \
		-H '$($(PKG)_HASH_FILE)' \
		$(QUIET) \
		-- \
		'$(call stripurischeme,$(call qstrip,$(1)))' \
		$($(PKG)_DL_OPTS)
endef

define SOURCE_CHECK_SCP
	$(SSH) $(call domain,$(1),:) ls '$(call notdomain,$(1),:)' > /dev/null
endef

define DOWNLOAD_HG
	$(EXTRA_ENV) $(DL_WRAPPER) -b hg \
		-o $(DL_DIR)/$($(PKG)_SOURCE) \
		$(QUIET) \
		-- \
		$($(PKG)_SITE) \
		$($(PKG)_DL_VERSION) \
		$($(PKG)_RAW_BASE_NAME) \
		$($(PKG)_DL_OPTS)
endef

# TODO: improve to check that the given PKG_DL_VERSION exists on the remote
# repository
define SOURCE_CHECK_HG
	$(HG) incoming --force -l1 $($(PKG)_SITE) > /dev/null
endef

define DOWNLOAD_WGET
	$(EXTRA_ENV) $(DL_WRAPPER) -b wget \
		-o $(DL_DIR)/$(2) \
		-H '$($(PKG)_HASH_FILE)' \
		$(QUIET) \
		-- \
		'$(call qstrip,$(1))' \
		$($(PKG)_DL_OPTS)
endef

define SOURCE_CHECK_WGET
	$(WGET) --spider '$(call qstrip,$(1))'
endef

define DOWNLOAD_LOCALFILES
	$(EXTRA_ENV) $(DL_WRAPPER) -b cp \
		-o $(DL_DIR)/$(2) \
		-H '$($(PKG)_HASH_FILE)' \
		$(QUIET) \
		-- \
		$(call stripurischeme,$(call qstrip,$(1))) \
		$($(PKG)_DL_OPTS)
endef
>>>>>>> origin/master

ifeq ($(BR2_PRIMARY_SITE_ONLY),)
DOWNLOAD_URIS += \
	$(patsubst %/,%,$(dir $(call qstrip,$(1))))
ifneq ($(call qstrip,$(BR2_BACKUP_SITE)),)
DOWNLOAD_URIS += \
	$(call getschemeplusuri,$(call qstrip,$(BR2_BACKUP_SITE)/$($(2)_DL_SUBDIR)),urlencode) \
	$(call getschemeplusuri,$(call qstrip,$(BR2_BACKUP_SITE)),urlencode)
endif
endif

################################################################################
# DOWNLOAD -- Download helper. Will call DL_WRAPPER which will try to download
# source from the list returned by DOWNLOAD_URIS.
#
# Argument 1 is the source location
# Argument 2 is the upper-case package name
#
################################################################################

define DOWNLOAD
	$(Q)mkdir -p $($(2)_DL_DIR)
	$(Q)$(EXTRA_ENV) flock $($(2)_DL_DIR)/ $(DL_WRAPPER) \
		-c '$($(2)_DL_VERSION)' \
		-d '$($(2)_DL_DIR)' \
		-D '$(DL_DIR)' \
		-f '$(notdir $(1))' \
		-H '$($(2)_HASH_FILE)' \
		-n '$($(2)_BASENAME_RAW)' \
		-N '$($(2)_RAWNAME)' \
		-o '$($(2)_DL_DIR)/$(notdir $(1))' \
		$(if $($(2)_GIT_SUBMODULES),-r) \
		$(foreach uri,$(call DOWNLOAD_URIS,$(1),$(2)),-u $(uri)) \
		$(QUIET) \
		-- \
		$($(2)_DL_OPTS)
endef
