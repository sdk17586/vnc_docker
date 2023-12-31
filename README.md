# rdv_webvnc

## docker pull base image
```bash
docker pull osrf/ros:melodic-desktop-full
```

## Building the Docker Image
```bash
docker build -t web_vnc .
```

## Running the Docker Container
```bash
docker run -it \
    --privileged \
    --gpus all \
    --net=host \
    -e NVIDIA_DRIVER_CAPABILITIES=all \
    -e __GLX_VENDOR_LIBRARY_NAME=nvidia \
    -e DISPLAY=:9 \
    -e QT_X11_NO_MITSHM=1 \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v /etc/localtime:/etc/localtime:ro \
    -e TZ=Asia/Seoul \
    --entrypoint /bin/bash \
    --name web_vnc \
    web_vnc:latest
```

## vnc start
```bash
docker exec -it web_vnc bash

./root/web_vnc_view/run_nopasswd.sh
```
## host setting(root)
```bash
sudo rm /tmp/.X11-unix/X9
```
```bash
sudo visudo
#아래의 내용 추가
rdv ALL=(ALL:ALL) NOPASSWD:ALL
```
```bash
mkdir -p /home/rdv/rdv_webvnc/log/docker_start
mkdir -p /home/rdv/rdv_webvnc/log/nopasswd
mkdir -p /home/rdv/rdv_webvnc/log/vnc
```
```bash
crontab -e

@reboot /bin/bash /home/rdv/rdv_webvnc/docker_start.sh >> /home/rdv/rdv_webvnc/log/docker_start/docker_start_$(date +\%Y-\%m-\%d_\%H-\%M-\%S).log 2>&1
@reboot /usr/bin/docker exec web_vnc /root/web_vnc_view/run_nopasswd.sh >> /home/rdv/rdv_webvnc/log/nopasswd/nopasswd_$(date +\%Y-\%m-\%d_\%H-\%M-\%S).log 2>&1
@reboot /bin/bash /home/rdv/rdv_webvnc/docker_vnc.sh >> /home/rdv/rdv_webvnc/log/vnc/vnc_$(date +\%Y-\%m-\%d_\%H-\%M-\%S).log 2>&1
```
