# ubuntu with Mate and noVNC

## What is this ubuntu_mate_novnc?

It is a Ubuntu zesty  image with x11vnc, novnc and the Mate desktop environment installed. You can use it as a desktop or as the basis for a more customized

## Example Usage

### Basic

```
docker run -d -P darklight/ubuntu_mate_novnc:16.04
```

### Static port

```
docker run -d -p 5900:5900 -p 6080:6080 darklight/ubuntu_mate_novnc:16.04
```

## Noteworthy

### Exposed ports

- x11vnc is exposed on port `5900`
- noVNC's http interface is exposed on port `6080`

### Misc.
- Default user/passwd is $DESKTOP_USERNAME
- Default VNC password is currently the same as `DESKTOP_USERNAME`. See TODO in next section. It can be easily changed at runtime with:

```
x11vnc -storepasswd somePassword /home/${DESKTOP_USERNAME}/.vnc/passwd
```

### NoVNC base image
This image is based on my ubuntu_novnc image. If you are using it to build your own image you may want to be familiar with it as some of the settings we use here are set in that image (like username) due to necessity/architecture.

### TODO

- support for ssl
- dynamically generated VNC password
