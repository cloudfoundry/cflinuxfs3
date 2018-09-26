Cloud Foundry stack: cflinuxfs3
====================

This stack is derived from Ubuntu 18.04 (Bionic Beaver)

# Dependencies

* GNU make
* Docker

# Creating a rootfs tarball

To create a rootfs for the cflinuxfs3 stack:

```shell
make
```

This will create the `cflinuxfs3.tar.gz` file, which is the artifact used as the rootfs in Cloud Foundry deployments.

# Creating a BOSH release from the rootfs tarball

To start, clone the [repository](https://github.com/cloudfoundry/cflinuxfs3-release) containing the cflinuxfs3-rootfs BOSH release:

```shell
git clone git@github.com:cloudfoundry/cflinuxfs3-release.git
cd cflinuxfs3-release
```

Replace the old cflinuxfs3 tarball with the new tarball created above:

```shell
rm -f config/blobs.yml
mkdir -p blobs/rootfs
cp <path-to-new-tarball>/cflinuxfs3.tar.gz blobs/rootfs/cflinuxfs3-new.tar.gz
```

Create a dev release and upload it to your BOSH deployment:

```shell
bosh create release --force --with-tarball --name cflinuxfs3-rootfs
bosh upload release <generated-dev-release-tar-file>
```

If your Diego deployment manifest has `version: latest` indicated for the `cflinuxfs3` release, then redeploying Diego will enable this new rootfs.

# Release pipeline

The generation and release of a new rootfs happens on the [cflinuxfs3](https://buildpacks.ci.cf-app.com/pipelines/cflinuxfs3) CI pipeline.

* A new stack is generated with `make`.

* A dev BOSH release of that new stack is generated and deployed to a BOSH Lite deployment.

* CF and Diego are deployed to that BOSH Lite. The [cf-acceptance-tests](https://github.com/cloudfoundry/cf-acceptance-tests) are then run against the deployment.

* Once all tests pass and the product manager ships the release, the rootfs tarball can be found as a [Github Release](https://github.com/cloudfoundry/cflinuxfs3/releases), [Docker Image](https://registry.hub.docker.com/u/cloudfoundry/cflinuxfs3/), and as a [BOSH release](https://github.com/cloudfoundry/cflinuxfs3-release).
