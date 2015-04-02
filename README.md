Miscellaneous BOSH helper scripts
=================================

manifest_bosh_info.sh
---------------------

```
./bin/manifest_bosh_info.sh test/manifests/cf-bosh-lite.yml
```

Looks up the `director_uuid` from the target manifest in your `~/.bosh_config` and runs `bosh status` against the matching BOSH director.
