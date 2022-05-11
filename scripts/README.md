**First export the RO(ReadOnly) user credentials for pulling the private docker images**

```BASH
export DOCK_USER="<SAMPLE_CRED>"
export DOCK_PASS="<SAMPLE_CRED>"
```

**Edit the script at line 18 & 19 for configuring custom registry
```
TARGET_IMAGE_REGISTRY="docker.io"
TARGET_REPONAME="jonsy13"
```

**Give execution permission to helper script**
```BASH
chmod +x ./litmus_image_push.sh
```
**For pulling images**

```BASH
./litmus_image_push.sh pull
```

**For listing all images**

```BASH
./litmus_image_push.sh list
```

**For Pushing all Images to new registry**

1. First export credentials for new registry

```BASH
export DOCK_USER="<SAMPLE_CRED>"
export DOCK_PASS="<SAMPLE_CRED>"
```

2. Then, push the images

```BASH
./litmus_image_push.sh push
```