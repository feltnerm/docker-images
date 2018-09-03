DOCKER_BIN := docker

IMAGES_ROOT_DIR := images

IMAGE_PREFIX := feltnerm

BUILD_DATE = $(shell date +"%Y%m%d")

image-dir = $(IMAGES_ROOT_DIR)/$1
image-version-manifest = $(IMAGES_ROOT_DIR)/$1/version.txt
image-fqdn = $(IMAGE_PREFIX)/$1

define image-rules

# Get the image version from `version.txt`
_image-version-$1:
	$(eval $@_VERSION := $(shell cat $(call image-version-manifest,$1)))

_base-$1: _image-version-$1

# Build an image
build-$1: _base-$1
	cd $(call image-dir,$1) && \
		$(DOCKER_BIN) build -t $(call image-fqdn,$1):$($@_VERSION)

# Tag an image and a snapshot
tag-$1: _base-$1
	$(DOCKER_BIN) tag $(call image-fqdn,$1):$($@_VERSION) $(call image-fqdn,$1):$($@_VERSION)-$(BUILD_DATE)

# Push the current and snapshot tags of an image
push-$1: tag-$1
	$(DOCKER_BIN) push $(call image-fqdn,$1):$($@_VERSION)
	$(DOCKER_BIN) push $(call image-fqdn,$1):$($@_VERSION)-$(BUILD_DATE)

# Remove all traces of the current and snapshot tags of an image
clean-$1:
	$(DOCKER_BIN) rmi -f $(call image-fqdn,$1):$($@_VERSION) || true
	$(DOCKER_BIN) rmi -f $(call image-fqdn,$1):$($@_VERSION)-$(BUILD_DATE) || true

# Check sanity
echo-$1: _image-version-$1
	@echo "Image Name:      " $1
	@echo "Version:         " $($@_VERSION)
	@echo "Tagged Version:  " $(call image-fqdn,$1):$($@_VERSION)
	@echo "Tagged Snapshot: " $(call image-fqdn,$1):$($@_VERSION)-$(BUILD_DATE)
	@echo "Build directory contents:\n" && cd $(call image-dir,$1) && ls -la

.PHONY: _image-version-$1 _base-$1 build-$1 tag-$1 push-$1 clean-$1 echo-$1
endef

# Defines the following rules for the specified images:
# Creates rules for the specified image
add-image= $(eval $(call image-rules,$1))

# Create rules for all images
IMAGES := $(notdir $(wildcard $(IMAGES_ROOT_DIR)/*))
$(foreach p,$(IMAGES),$(call add-image,$p))
