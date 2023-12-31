# Dockerfile

FROM osrf/ros:melodic-desktop-full

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -f && \
    apt-get install -y \
    lsof \
    xauth \
    xfce4 \
    xfce4-goodies \
    vim \
    && rm -rf /var/lib/apt/lists/* 

RUN apt-get remove -y xfce4-panel || true

RUN git clone https://github.com/sdk17586/web_vnc_view.git /root/web_vnc_view && \
    cd /root/web_vnc_view && \
    git submodule update --init

WORKDIR /root/web_vnc_view

RUN chmod +x install_script.sh && \
    ./install_script.sh

EXPOSE 5900 80

CMD ["bash", "-c", "./start_vnc_server.sh"]
