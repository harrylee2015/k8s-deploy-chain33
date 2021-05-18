#!/bin/bash
#集群名称
CLUSTER_NAME=$1
#副本数(节点总数）
REPLICAS=$2
#部署目录
DEPLOY_DIR=$3

#CONFIG_ITEMS
ITEMS=""
for i in `seq 0 $REPLICAS`
do
  if [[ $i -eq $REPLICAS ]]; then
    break
  fi
  ITEMS=$ITEMS"
          - key: priv_validator_$i.json
            path: priv_validator_$i.json
  "
done

#SEEDS, VALIDATORNODES
# seeds=["${chain33_0}:13802","${chain33_1}:13802","${chain33_2}:13802","${chain33_3}:13802"]
# validatorNodes=["${chain33_0}:46656","${chain33_1}:46656","${chain33_2}:46656","${chain33_3}:46656"]
SEEDS=""
VALIDATORNODES=""
for i in `seq 0 $REPLICAS`
do
  if [[ $i -eq $REPLICAS ]]; then
    break
  fi
  if [[ 0 -eq $i ]]; then
    SEEDS=\"\${CLUSTER_NAME}_$i:13802\"
    VALIDATORNODES=\"\${CLUSTER_NAME}_$i:46656\"
  else
    SEEDS=${SEEDS},\"\${CLUSTER_NAME}_$i:13802\"
    VALIDATORNODES=${VALIDATORNODES},\"\${CLUSTER_NAME}_$i:46656\"
  fi
done

mkdir -p ${DEPLOY_DIR}/${CLUSTER_NAME}
#从镜像中copy chain33-cli可执行文件，生成私钥
IMAGE=chain33:1.0.2
docker pull ${IMAGE}
docker run --rm --name chain33 chain33:v1.0.2 /bin/bash -c "sleep 30"
docker cp  chain33:/app/chain33/*.yaml ${DEPLOY_DIR}
docker cp  chain33:/app/chain33/chain33-cli ${DEPLOY_DIR}

cd ${DEPLOY_DIR}
#生成节点私钥
./chain33-cli valnode init_keyfile -t bls -n ${REPLICAS}
#genesis.json
GENESIS=$(cat genesis.json)
GENESIS="
  genesis.json: |
    ${GENESIS}"
#priv_validator
PRIV_VALIDATOR=""
for i in `seq 0 $REPLICAS`
do
  if [[ $i -eq $REPLICAS ]]; then
    break
  fi
  PRIV=$(cat priv_validator_$i)
  PRIV_VALIDATOR=${PRIV_VALIDATOR}"
  priv_validator_0.json: |
    $PRIV"
done

#替换实际变量
eval "cat <<EOF
$(cat chain33-config.yaml)
EOF
" >${CLUSTER_NAME}/chain33-config.yaml
if [ "$?" -ne 0 ]; then
  echo "replace chain33-config.yaml failed!"
  exit 1
fi

eval "cat <<EOF
$(cat chain33-service.yaml)
EOF
" >${CLUSTER_NAME}/chain33-service.yaml
if [ "$?" -ne 0 ]; then
  echo "replace chain33-service.yaml failed!"
  exit 1
fi

eval "cat <<EOF
$(cat chain33-statefulSet.yaml)
EOF
" >${CLUSTER_NAME}/chain33-statefulSet.yaml
if [ "$?" -ne 0 ]; then
  echo "replace chain33-statefulSet.yaml failed!"
  exit 1
fi

eval "cat <<EOF
$(cat chain33-storageClass.yaml)
EOF
" >${CLUSTER_NAME}/chain33-storageClass.yaml
if [ "$?" -ne 0 ]; then
  echo "replace chain33-storageClass.yaml failed!"
  exit 1
fi

#开始部署
cd ${CLUSTER_NAME}
./kubectl apply -f chain33-storageClass.yaml
sleep 1
./kubectl apply -f chain33-config.yaml
sleep 1
./kubectl apply -f chain33-service.yaml
sleep 1
./kubectl apply -f chain33-statefulSet.yaml