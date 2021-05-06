#!/bin/bash
# author： harry
# describe: 为支持在k8s中部署chain33而写的init container脚本
# 环境变量导入
sleep 10
source ./env
local_hostname=$(hostname)
local_domain=$(hostname -f)
hostnames=`cat hosts`
rm -rf ips
for i in $hostnames
do
domain=$(echo ${local_domain}|sed -e "s/${local_hostname}./${i}./g")
IP=`ping $i -c 1 |awk 'NR==2 {print $4}' |awk -F ':' '{print $1}'`
    echo $i=$IP >> ips
done
#导入解析主机信息
source ./ips
#替换实际变量
eval "cat <<EOF
$(cat base.toml)
EOF
" >chain33.toml
if [ "$?" -ne 0 ]; then
  echo "replace chain33.toml failed!"
  exit 1
fi
echo "replace chain33.toml sucessfully!"