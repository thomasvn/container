# Checksums for container images

Why are they so seemingly simple, yet so absolutely confusing?? Let's investigate

## Getting Started

It's best to start by peeling open the filesystem of a container so that we can poke around its internals.

```bash
# Pull image and save to Tar file
$ docker pull httpd@sha256:fba8a9f4290180ceee5c74638bb85ff21fd15961e6fdfa4def48e18820512bb1
$ docker save -o httpd.tar httpd

# Extract Tar file
$ mkdir httpd-image
$ tar -xvf httpd.tar -C httpd-image
$ find .
./manifest.json
./ea28e1b82f314092abd3f90a69e57d6ccf506382821ee0b8d9b48c3e47440c1f.json
./repositories
./450c717e9a3897e4486af870bcd878516429c05af5c1393661cc2b306bf96cc2
  ./450c717e9a3897e4486af870bcd878516429c05af5c1393661cc2b306bf96cc2/layer.tar
  ./450c717e9a3897e4486af870bcd878516429c05af5c1393661cc2b306bf96cc2/json
  ./450c717e9a3897e4486af870bcd878516429c05af5c1393661cc2b306bf96cc2/VERSION
./88306c54a25270d94efb5df69514b85e46569921b6da5f774f2655caf218fcc3
  ./88306c54a25270d94efb5df69514b85e46569921b6da5f774f2655caf218fcc3/layer.tar
  ./88306c54a25270d94efb5df69514b85e46569921b6da5f774f2655caf218fcc3/json
  ./88306c54a25270d94efb5df69514b85e46569921b6da5f774f2655caf218fcc3/VERSION
./48f384ef5bf80e823ac5fc05535fe875418037c2e1455da61d74fb9e1936fbaf
  ./48f384ef5bf80e823ac5fc05535fe875418037c2e1455da61d74fb9e1936fbaf/layer.tar
  ./48f384ef5bf80e823ac5fc05535fe875418037c2e1455da61d74fb9e1936fbaf/json
  ./48f384ef5bf80e823ac5fc05535fe875418037c2e1455da61d74fb9e1936fbaf/VERSION
./5cf759b2ca03270b3b8eff486ea382370ab23e444f83f7674ec2174a0b0a3b7d
  ./5cf759b2ca03270b3b8eff486ea382370ab23e444f83f7674ec2174a0b0a3b7d/layer.tar
  ./5cf759b2ca03270b3b8eff486ea382370ab23e444f83f7674ec2174a0b0a3b7d/json
  ./5cf759b2ca03270b3b8eff486ea382370ab23e444f83f7674ec2174a0b0a3b7d/VERSION
./b33ddbe0419d930e30e43f2c725044648577c8e9a984b01f426ffa29d4747292
  ./b33ddbe0419d930e30e43f2c725044648577c8e9a984b01f426ffa29d4747292/layer.tar
  ./b33ddbe0419d930e30e43f2c725044648577c8e9a984b01f426ffa29d4747292/json
  ./b33ddbe0419d930e30e43f2c725044648577c8e9a984b01f426ffa29d4747292/VERSION
```

Notice three main files at the top of the directory `manifest.json`, `json`, and `repositories`. Then each layer of the container image has a `layer.tar`, `json`, and `VERSION`.

## The Many Different SHA256 Checksums

```bash
# Docker Image ID
# This comes from the hash of the "config.json"
$ docker images
httpd   latest    ea28e1b82f31    6 days ago    143MB

$ ls httpd-image
450c717e9a3897e4486af870bcd878516429c05af5c1393661cc2b306bf96cc2
48f384ef5bf80e823ac5fc05535fe875418037c2e1455da61d74fb9e1936fbaf
5cf759b2ca03270b3b8eff486ea382370ab23e444f83f7674ec2174a0b0a3b7d
88306c54a25270d94efb5df69514b85e46569921b6da5f774f2655caf218fcc3
b33ddbe0419d930e30e43f2c725044648577c8e9a984b01f426ffa29d4747292
ea28e1b82f314092abd3f90a69e57d6ccf506382821ee0b8d9b48c3e47440c1f.json
manifest.json
repositories
```

```bash
# Distribution Digest (from docker pull)
# The hash referenced here is the SHA256 of the manifest.json
$ docker pull httpd@sha256:fba8a9f4290180ceee5c74638bb85ff21fd15961e6fdfa4def48e18820512bb1
Using default tag: latest
latest: Pulling from library/httpd
Digest: sha256:fba8a9f4290180ceee5c74638bb85ff21fd15961e6fdfa4def48e18820512bb1
Status: Image is up to date for httpd:latest
docker.io/library/httpd:latest

# You'll just have to trust me on this one
# The local manifest.json is different from the manifest.json when it was on the Dockerhub registry
$ openssl sha256 httpd-image/manifest.json
SHA256(httpd-image/manifest.json)= caddbebaaa74b1e6ffb7cb0c2bb5d4969bf2fc05291bea396fb87abcf28008e8

$ docker manifest inspect httpd > test.txt
openssl sha256 test.txt
```

## References

- <https://stackoverflow.com/questions/56364643/whats-the-difference-between-a-docker-images-image-id-and-its-digest>

<!--
TODO:
- hash of the manifest?
  - https://github.com/opencontainers/image-spec/blob/main/manifest.md
- hash of the layers of the image
- https://windsock.io/explaining-docker-image-ids/
- https://github.com/opencontainers/image-spec/blob/main/descriptor.md#digests
- /var/lib/docker/overlay2/
  - requires SSH into Docker VM
-->
