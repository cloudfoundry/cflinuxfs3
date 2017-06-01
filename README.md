Cloud Foundry cflinuxfs3
====================

This repo contains scripts for creating garden root filesystems.

* cflinuxfs3 derived from Ubuntu 16.04.02 (Xenial Xerus)

# Dependencies

* GNU make
* Docker

# Adding a new package to the rootfs

`cflinuxfs3/build/install-packages.sh` has a list of packages passed to `apt-get install` as well.

# Creating a rootfs tarball

To create a rootfs for the cflinuxfs3 stack:

```shell
make
```

This will create the `cflinuxfs3.tar.gz` file, which is the artifact used as the rootfs in Cloud Foundry deployments.

# Creating a BOSH release from the rootfs tarball

To start, clone the [repository](https://github.com/cloudfoundry/cflinuxfs3-release) containing the cflinuxfs3-rootfs BOSH release:

```shell
git clone git@github.com:cloudfoundry/cflinuxfs3-release.git`
cd cflinuxfs3-release`
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

Note: Diego doesn't consume cflinuxfs3 yet, so the manifest update might be different than below

If your Diego deployment manifest has `version: latest` indicated for the `cflinuxfs3-rootfs` release, then redeploying your Diego will enable this new rootfs to be used in your app containers.

# Testing the rootfs

To run the local tests, just run `rspec`. If the top level of this repo contains a file named `cflinuxfs3.tar.gz`, the tests will be run against this file. Otherwise, `make` will  be run to create a new rootfs.

To test the rootfs BOSH release, see the instructions [here](https://github.com/cloudfoundry/cflinuxfs3-release/blob/master/README.md)

# Release pipeline

The generation and release of a new rootfs happens on the [cflinuxfs3](https://buildpacks.ci.cf-app.com/pipelines/cflinuxfs3) CI pipeline.

* A new stack is generated with `make`.

* A dev BOSH release of that new stack is generated and deployed to a BOSH Lite on GCP and the rootfs smoke tests run.

* CF and Diego are deployed to that BOSH Lite. The [cf-acceptance-tests](https://github.com/cloudfoundry/cf-acceptance-tests) are then run against the deployment.

* Once all tests pass and the product manager ships the release, the rootfs tarball can be found as a [Github Release](https://github.com/cloudfoundry/cflinuxfs3/releases), [Docker Image](https://registry.hub.docker.com/u/cloudfoundry/cflinuxfs3/), and as a [BOSH release](https://github.com/cloudfoundry/cflinuxfs3-release).
