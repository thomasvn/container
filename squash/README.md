# Should you squash your containers?

It depends!

```bash
# Example
$ docker pull registry.hub.docker.com/library/nginx:1.21.3
$ docker build -t nginx:squash --squash .

# Size difference (uncompressed)
$ docker images
nginx   squash  d9140993d1c4   39 seconds ago   132MB
nginx   1.21.1  0b9a8be7f3ad   2 hours ago      336MB

# Size difference (compressed)
$ docker save nginx:1.21.1 -o nginx-1.21.1.tar && gzip --best nginx-1.21.1.tar
$ docker save nginx:squash -o nginx-squash.tar && gzip --best nginx-squash.tar
$ ls -la
-rw-------@  1 nguyentv  staff  114455667 Sep 17 16:31 nginx-1.21.1.tar.gz  # 114MB
-rw-------@  1 nguyentv  staff   51306376 Sep 17 16:32 nginx-squash.tar.gz  # 51MB

# Layers difference
```

Pros: Smaller container image. Easier to transmit and store.

Cons: Squashed images only container a single layer. Any changes to that layer (even a single line), will require you to download the full container image again. You cannot make use of cached layers.

## References

- <https://docs.docker.com/engine/reference/commandline/image_build/>

<!-- 
TODO:
- rerun squash build; messed up the first time
- how it works (diff when building each layer)
-->
