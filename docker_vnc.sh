#!/bin/bash

while true; do
    if ps -aux | grep -v grep | grep "python3 -m websockify --web /root/web_vnc_view/noVNC/utils/../ 6080 localhost:5909"; then
        echo "Websocket process found, proceeding..."
        break
    else
        echo "Waiting for websocket process..."
        sleep 1
    fi
done



# 컨테이너에서 xauth 리스트 가져오기
DOCKER_EXEC_RESULT=$(docker exec web_vnc xauth list 2>&1)

# :9로 끝나는 항목만 필터링
XAUTH_ENTRIES=$(echo "$DOCKER_EXEC_RESULT" | grep :9)

XAUTH_PATH=$(which xauth)

# rdv 사용자의 홈 디렉터리에서 .Xauthority 파일 경로
RDV_XAUTHORITY_PATH="/home/rdv/.Xauthority"

# XAUTH_ENTRIES의 각 줄을 처리
IFS=$'\n'
for line in $XAUTH_ENTRIES; do
    # 항목을 분해하여 변수에 저장
    DISPLAYNAME=$(echo $line | awk '{print $1}')
    PROTOCOLNAME=$(echo $line | awk '{print $2}')
    HEXKEY=$(echo $line | awk '{print $3}')

    # rdv 사용자에게 xauth 항목 추가
    ADD_RESULT=$(sudo -u rdv XAUTHORITY=$RDV_XAUTHORITY_PATH $XAUTH_PATH add $DISPLAYNAME $PROTOCOLNAME $HEXKEY 2>&1)
    if [ $? -eq 0 ]; then
        echo "Successfully added xauth entry for rdv user: $line"
    else
        echo "Failed to add xauth entry for rdv user: $line. Error: $ADD_RESULT"
    fi

    # root 사용자에게 xauth 항목 추가
    ADD_RESULT_ROOT=$(sudo XAUTHORITY=/root/.Xauthority $XAUTH_PATH add $DISPLAYNAME $PROTOCOLNAME $HEXKEY 2>&1)
    if [ $? -eq 0 ]; then
        echo "Successfully added xauth entry for root user: $line"
    else
        echo "Failed to add xauth entry for root user: $line. Error: $ADD_RESULT_ROOT"
    fi
done

export DISPLAY=:9

xhost +
