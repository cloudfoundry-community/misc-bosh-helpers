Miscellaneous BOSH helper scripts
=================================

A series of helper scripts to navigate around a maze of BOSH deployment manifests.

Inspired by https://blog.starkandwayne.com/2015/04/02/inspecting-bosh-manifests-in-bash/

Requirements
------------

-	bash 3.2+
-	golang - [install](http://golang.org/doc/install)
-	BOSH CLI
-	jq - http://stedolan.github.io/jq/
-	yaml2json - https://github.com/bronze1man/yaml2json

The latter can be installed with

```
go get github.com/bronze1man/yaml2json
```

Installation
------------

```
cd /usr/local
git clone https://github.com/cloudfoundry-community/misc-bosh-helpers.git
```

Then add the following to your `~/.bashrc` or `/etc/bash.bashrc` and restart your shell:

```
export PATH=$PATH:/usr/local/misc-bosh-helpers/bin
```

manifest_bosh_info
------------------

Looks up the `director_uuid` from the target manifest in your `~/.bosh_config` and runs `bosh status` against the matching BOSH director.

```
$ ./bin/manifest_bosh_info test/manifests/cf-bosh-lite.yml
```

find_manifests
--------------

Finds any BOSH deployment manifests within target path and subfolders.

```
$ ./bin/find_manifests
./test/manifests/cf-bosh-lite.yml
./test/manifests/cf-monitor-server.yml

$ ./bin/find_manifests test
./test/manifests/cf-bosh-lite.yml
./test/manifests/cf-monitor-server.yml
```

find_manifests_for_release
--------------------------

Finds BOSH manifests within target path and subfolders that use specified release name

```
$ ./bin/find_manifests_for_release cf
./test/manifests/cf-bosh-lite.yml
./test/manifests/cf-monitor-server.yml

$ ./bin/find_manifests_for_release monitor-server test/manifests
./test/manifests/cf-monitor-server.yml

$ ./bin/find_manifests_for_release xxx
<no result>
```

find_cf_manifest_for_api
------------------------

Finds CF BOSH manifest for a CF API (`-u uri`); or show all APIs for all CF manifests.

Show all CF APIs for all CF BOSH manifests:

```
$ ./bin/find_cf_manifest_for_api
./test/manifests/cf-bosh-lite.yml https://api.10.244.0.34.xip.io
./test/manifests/cf-monitor-server.yml https://api.10.244.10.34.xip.io
```

Find a specific CF BOSH manifest for a given API hostname:

```
$ ./bin/find_cf_manifest_for_api -u api.10.244.0.34.xip.io
./test/manifests/cf-bosh-lite.yml https://api.10.244.0.34.xip.io
```

```
$ ./bin/find_cf_manifest_for_api -u something.unknown.com
<no result>
```

NOTE: use `awk` to extract the filename from each result line:

```
$ ./bin/find_cf_manifest_for_api -u api.10.244.0.34.xip.io | awk '{print $1}'
./test/manifests/cf-bosh-lite.yml
```

Target the discovered BOSH manifest:

```
$ bosh deployment $(./bin/find_cf_manifest_for_api -u api.10.244.0.34.xip.io | awk '{print $1}')
Deployment set to `.../misc-bosh-helpers/test/manifests/cf-bosh-lite.yml'
```

find_micro_bosh
---------------

Find Micro BOSH manifests (like `micro_bosh.yml`\), the parent folder containing `bosh-workspace.yml`, and the assigned IP for the Micro BOSH:

```
$ ./bin/find_micro_bosh
.../aws_vpc/micro_bosh.aws_vpc.yml .../aws_vpc 10.10.3.4
.../openstack_nova/openstack/micro_bosh.openstack.nova_vip.yml .../openstack_nova/openstack 1.2.3.4
.../not-deployed-yet/micro-bosh.yml not-deployed null
```

If a Micro BOSH YAML file is found but no `bosh-deployment.yml` is found in the parent folders, then `not-deployed` is returned as the 2nd item on the result line (see above).

If a Micro BOSH YAML file doesn't yet specify the IP address then `null` is shown.

To only show `micro_bosh.yml` that have been deployed at least once:

```
$ find_micro_bosh | grep -v not-deployed
```
