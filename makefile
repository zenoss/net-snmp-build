PWD := $(shell pwd)
UID := $(shell id -u)
GID := $(shell id -g)

BUILD_IMAGE := zenoss/build-netsnmp

.PHONY: rpm

rpm: Dockerfile-rpm
	docker build --pull -f $< -t $(BUILD_IMAGE)-rpm .
	docker run --rm -v $(PWD):/mnt -w /mnt $(BUILD_IMAGE)-rpm make -f build.mk
	docker run --rm -v $(PWD):/mnt -w /mnt $(BUILD_IMAGE)-rpm make -f rpm.mk

rpm-only:
	docker run --rm -v $(PWD):/mnt -w /mnt $(BUILD_IMAGE)-rpm make -f rpm.mk

clean:
	@rm -f Dockerfile-rpm
	@make -f build.mk clean
	@make -f rpm.mk clean

Dockerfile-rpm: Dockerfile-rpm.in
	@sed -e "s/%GID%/$(GID)/" -e "s/%UID%/$(UID)/" $< > $@
