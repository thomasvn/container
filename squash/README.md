# Should you squash your containers?

It depends!

```bash
# Example
$ docker build -t example:bloat .
$ docker build -t example:squash --squash .

# Size difference (uncompressed)
$ docker images
REPOSITORY        TAG           IMAGE ID       CREATED          SIZE
example           squash        8f4e98b374e1   23 seconds ago   271MB
example           bloat         e8e778dbf9b0   28 seconds ago   601MB

# Size difference (compressed)
$ docker save example:bloat -o bloat.tar && gzip --best bloat.tar
$ docker save example:squash -o squash.tar && gzip --best squash.tar
$ ls -la
-rw-------   1 thomasvn  me  220350390 Dec  9 17:10 bloat.tar.gz     # 220MB
-rw-------   1 thomasvn  me  103033483 Dec  9 17:11 squash.tar.gz    # 103MB
```

Remember, both these container images are functionally the same. Their file systems look exactly the same in the final layer.

However, they differ drastically in size due to all the files which exist in the intermediary layers of the image which are no longer present in the final layer.

## Quick takeaway

Pros: Smaller container image. Easier to transmit and store.

Cons: Squashed images only contain a single layer. Any changes to that layer (even a single line in the Dockerfile), will require you to rebuild/re-download the full container image again. You cannot make use of cached layers.

## Under the hood

The initial bloated image has three layers (shown below):

- `FROM centos`
- `RUN yum install -y skopeo ruby maven`
- `RUN yum remove -y skopeo ruby maven`

When running the container, we'll find that `skopeo`, `ruby`, and `maven` are not installed. However their installations still live in the layers we have saved for the image.

```bash
$ docker inspect example:bloat
    "GraphDriver": {
        "Data": {
            "LowerDir": "/var/lib/docker/overlay2/kgo2rio22pondzboimfo5mweq/diff:/var/lib/docker/overlay2/4f2c344e5e9411f00c4c72bd2b7944555533d553de0107436f58caacd48157eb/diff",
            "MergedDir": "/var/lib/docker/overlay2/ia51kj04q606n4o9spmmx5bq9/merged",
            "UpperDir": "/var/lib/docker/overlay2/ia51kj04q606n4o9spmmx5bq9/diff",
            "WorkDir": "/var/lib/docker/overlay2/ia51kj04q606n4o9spmmx5bq9/work"
        },
        "Name": "overlay2"
    },
    "RootFS": {
        "Type": "layers",
        "Layers": [
            "sha256:74ddd0ec08fa43d09f32636ba91a0a3053b02cb4627c35051aff89f853606b59",
            "sha256:d7eebc773767f5c8864cfc967b323bebfe120941e7ba677be3083d273c1bebd2",
            "sha256:b388eb25641af659fe9c669838722b44ec0a24435812bc0111079ae21beac14e"
        ]
    },
```

However in the squashed image there is only one layer. The squashed image was built by taking a diff of every new layer and only keeping that diff. In otherwords, since `skopeo` `ruby` and `maven` were installed then uninstalled, they do not exist in the final container image.

```bash
$ docker inspect example:squash
    "GraphDriver": {
        "Data": {
            "MergedDir": "/var/lib/docker/overlay2/74097dc3165ff4e8579659642c19f8e3e3e8cc4ec6882285367d23486afe72cb/merged",
            "UpperDir": "/var/lib/docker/overlay2/74097dc3165ff4e8579659642c19f8e3e3e8cc4ec6882285367d23486afe72cb/diff",
            "WorkDir": "/var/lib/docker/overlay2/74097dc3165ff4e8579659642c19f8e3e3e8cc4ec6882285367d23486afe72cb/work"
        },
        "Name": "overlay2"
    },
    "RootFS": {
        "Type": "layers",
        "Layers": [
            "sha256:7133d00284e3f6222bb85d6de520d14c2e397755c010a5ce2e23d008ee37cb9e"
        ]
    },    
```

## References

- <https://docs.docker.com/engine/reference/commandline/image_build/>
- <https://stackoverflow.com/questions/41764336/how-does-the-new-docker-squash-work>

<!-- 
TODO:
- refine the wording
- draw pictures
-->
