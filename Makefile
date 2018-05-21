BASE = ubuntu:bionic
ARCH = x86_64
NAME = cflinuxfs3

all: $(NAME).tgz

$(NAME).iid:
	docker build \
	--build-arg "base=${BASE}" \
	--build-arg "arch=${ARCH}" \
	--build-arg packages="`cat "packages/${NAME}" "arch/${ARCH}/packages/${NAME}" 2>/dev/null`" \
	--build-arg locales="`cat locales`" \
	--no-cache "--iidfile=${NAME}.iid" .

# TODO: use make option in pipeline to ensure $(NAME).iid is always rebuilt
$(NAME).tgz: $(NAME).iid
	docker run "--cidfile=${NAME}.cid" "`cat "${NAME}.iid"`" dpkg -l | tee "receipt.${NAME}.${ARCH}"
	docker export "`cat "${NAME}.cid"`" | gzip > "${NAME}.tgz"
	docker rm -f "`cat "${NAME}.cid"`"
	rm -f "${NAME}.cid"
