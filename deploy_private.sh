#!/bin/bash

# --- Private 서버 정보 ---
PRIVATE_HOST="10.10.20.6"          # 실제 Private 서버 IP(본인걸로 바꿔야함)
PRIVATE_USER="root"                 # Private 서버 계정(실제로는 root보다는 권한을 갖고 있는 다른 계정 사용 추천)
PRIVATE_KEY="/root/.ssh/id_rsa"     # Public 서버에서 Private 서버 접속용 사설 키

# --- 실행 후 로그 남기기(문제 있으면 해당 경로로 가서 로그 확인해보기) --- 
exec > /root/app/deploy_private.log 2>&1
echo "Starting deployment to Private server..."


eval $(ssh-agent -s)
ssh-add $PRIVATE_KEY


ssh -o StrictHostKeyChecking=no $PRIVATE_USER@$PRIVATE_HOST "mkdir -p /root/app"


scp -o StrictHostKeyChecking=no /root/app/build/libs/*.jar $PRIVATE_USER@$PRIVATE_HOST:/root/app/app.jar


ssh -o StrictHostKeyChecking=no $PRIVATE_USER@$PRIVATE_HOST "nohup java -jar /root/app/app.jar > /root/app/app.log 2>&1 &"

ssh -o StrictHostKeyChecking=no $PRIVATE_USER@$PRIVATE_HOST "bash </root/deploy.sh"

ssh-agent -k

echo "Deployment to Private server completed."