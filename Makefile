BASE=ubuntu:bionic
ARCH=x86_64

all: cflinuxfs3.tgz

cflinuxfs3.iid:
	docker build \
	--build-arg base="${BASE}" \
	--build-arg arch="${ARCH}" \
	--build-arg packages="`cat packages arch/${ARCH}/packages`" \
	--build-arg locales="`cat locales`" \
	--no-cache --iidfile=cflinuxfs3.iid .

# TODO: use make option in pipeline to ensure cflinuxfs3.iid is always rebuilt
cflinuxfs3.tgz: cflinuxfs3.iid
	docker run --cidfile=cflinuxfs3.cid "$(shell cat cflinuxfs3.iid)" dpkg -l | tee "receipt.${ARCH}"
	docker export "$(shell cat cflinuxfs3.cid)" | gzip > cflinuxfs3.tgz
	docker rm -f "$(shell cat cflinuxfs3.cid)"
	rm -f cflinuxfs3.cid
