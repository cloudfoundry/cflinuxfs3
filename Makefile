ARCH := x86_64
NAME := cflinuxfs3
BASE := ubuntu:bionic
BUILD := $(NAME).$(ARCH)

all: $(BUILD).tgz

$(BUILD).iid:
	docker build \
	--build-arg "base=$(BASE)" \
	--build-arg "arch=$(ARCH)" \
	--build-arg packages="`cat "packages/$(NAME)" "arch/$(ARCH)/packages/$(NAME)" 2>/dev/null`" \
	--build-arg locales="`cat locales`" \
	--no-cache "--iidfile=$(BUILD).iid" .

# TODO: use make option in pipeline to ensure $(BUILD).iid is always rebuilt
$(BUILD).tgz: $(BUILD).iid
	docker run "--cidfile=$(BUILD).cid" `cat "$(BUILD).iid"` dpkg -l | tee "receipt.$(BUILD)"
	docker export `cat "$(BUILD).cid"` | gzip > "$(BUILD).tgz"
	shasum -a 256 "$(BUILD).tgz" >> "receipt.$(BUILD)"
	docker rm -f `cat "$(BUILD).cid"`
	rm -f "$(BUILD).cid"
