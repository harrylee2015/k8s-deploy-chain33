#!/bin/bash
# author： harry
# describe: 为支持在k8s中部署chain33而写的在pod中动态修改配置文件脚本
# 环境变量导入  env其他参数配置信息,$REPLICAS副本数，对链而言则是节点数 $POD_NAME_PREFIX pod名称前缀
sleep 10
source ./config/env
local_hostname=$(hostname)
local_domain=$(hostname -f)
rm -rf ips
for i in `seq 0 $REPLICAS`
do
  if [[ $i -eq $REPLICAS ]]; then
    break
  fi
  cp  config/priv_validator_$i.json priv_validator.json
  cp  config/genesis.json  genesis.json
  cp  config/base.toml  base.toml
  domain=$(echo ${local_domain}|sed -e "s/${local_hostname}./${POD_NAME_PREFIX}-${i}./g")
  for j in `seq 1 150`
  do
    echo "=========try ping times=======: $j"
    IP=$(ping $domain -c 1 |awk 'NR==2 {print $5}' |awk -F ':' '{print $1}' |sed -nr "s#\(##gp"|sed -nr "s#\)##gp")
    if [[ -n "$IP" ]]; then
      echo "$i=$IP" >> ips
      break
    fi
    sleep 1
  done
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
sleep 5
echo "replace chain33.toml sucessfully!"
# 启动命令
./chain33 -f chain33.toml