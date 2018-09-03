docker-images
----

@feltnerm's docker images!

# Development

## Adding a new image

Create a new directory in `./images/`.
Copy the files from the template found in `./images/__template__`.
This includes **version.txt** which is read to get the current version for
tagging, **README.md** which should describe the image, **LICENSE**, and any
other _base_ files.

## `make` commands

_All commands prefixed with `make`_.

_"current version" is the current version specified in the relative
`version.txt`._

_"snapshot" is a tag with the current version and date (granular to the day)._

| Command | Description |
| --- | --- |
| `build-<image-name>` |  Build the current version of the image locally |
| `tag-<image-name>` | Tag the current version and a snapshot of the image |
| `push-<image-name>` | Push the latest build of the current version and a snapshot to the registry |
| `clean-<image-name>` | Remove the latest build of the current version and snapshot locally |
| `echo-<image-name>` | Output debug information about an image repo |
