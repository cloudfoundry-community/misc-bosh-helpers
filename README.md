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

manifest_bosh_info.sh
---------------------

Looks up the `director_uuid` from the target manifest in your `~/.bosh_config` and runs `bosh status` against the matching BOSH director.

```
$ ./bin/manifest_bosh_info.sh test/manifests/cf-bosh-lite.yml
```

find_manifests.sh
-----------------

Finds any BOSH deployment manifests within target path and subfolders.

```
$ ./bin/find_manifests.sh
./test/manifests/cf-bosh-lite.yml
./test/manifests/cf-monitor-server.yml

$ ./bin/find_manifests.sh test
./test/manifests/cf-bosh-lite.yml
./test/manifests/cf-monitor-server.yml
```

find_manifests_for_release.sh
-----------------------------

Finds BOSH manifests within target path and subfolders that use specified release name

```
$ ./bin/find_manifests_for_release.sh cf
./test/manifests/cf-bosh-lite.yml
./test/manifests/cf-monitor-server.yml

$ ./bin/find_manifests_for_release.sh monitor-server test/manifests
./test/manifests/cf-monitor-server.yml

$ ./bin/find_manifests_for_release.sh xxx
<no result>
```

find_cf_manifest_for_api.sh
---------------------------

Finds CF BOSH manifest for a CF API (`-u uri`); or show all APIs for all CF manifests.

Show all CF APIs for all CF BOSH manifests:

```
$ ./bin/find_cf_manifest_for_api.sh
./test/manifests/cf-bosh-lite.yml https://api.10.244.0.34.xip.io
./test/manifests/cf-monitor-server.yml https://api.10.244.10.34.xip.io
```

Find a specific CF BOSH manifest for a given API hostname:

```
$ ./bin/find_cf_manifest_for_api.sh -u api.10.244.0.34.xip.io
./test/manifests/cf-bosh-lite.yml https://api.10.244.0.34.xip.io
```

```
$ ./bin/find_cf_manifest_for_api.sh -u something.unknown.com
<no result>
```

NOTE: use `awk` to extract the filename from each result line:

```
$ ./bin/find_cf_manifest_for_api.sh -u api.10.244.0.34.xip.io | awk '{print $1}'
./test/manifests/cf-bosh-lite.yml
```

Target the discovered BOSH manifest:

```
$ bosh deployment $(./bin/find_cf_manifest_for_api.sh -u api.10.244.0.34.xip.io | awk '{print $1}')
Deployment set to `.../misc-bosh-helpers/test/manifests/cf-bosh-lite.yml'
```

find_micro_bosh.sh
------------------

Find Micro BOSH manifests (like `micro_bosh.yml`\) and the parent folder containing `bosh-workspace.yml`:

```
$ ./bin/find_micro_bosh.sh
./bin/find_micro_bosh.sh
.../microboshes/aws_vpc/micro_bosh.aws_vpc.yml .../microboshes/aws_vpc
.../microboshes/openstack_nova/openstack/micro_bosh.openstack.nova_vip.yml .../microboshes/openstack_nova/openstack
.../microboshes/not-deployed-yet/micro-bosh.yml not-deployed
```

If a Micro BOSH YAML file is found but no `bosh-deployment.yml` is found in the parent folders, then `not-deployed` is returned as the 2nd item on the result line (see above).
