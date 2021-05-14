# k8s-deploy-chain33  v1.0.2版本操作说明

## yaml配置文件功能简介

   名称|功能
   ----|----
   chain33-config.yaml| k8s中启动chain33所需要的配置文件，做成configMap资源
   chain33-pvc.yaml|创建一个数据卷(这步只是手动测试创建,后面在statefulset中有模板会自动创建)
   chain33-service.yaml|创建一个无厘头服务，我们脚本中域名地址解析需要用到它
   chain33-storageClass.yaml|创建一个存储类型，这里只是定义虚拟磁盘的概念，有slow和fast
   chain33-statefulSet.yaml|核心文件，通过statefulset定义一条联盟链，副本数代表联盟链节点数
   
## 操作部署

 1.创建chain33 service
 ```
  kubectl apply -f chain33-service.yaml
 ```
 2.创建chain33-config
 ```
   kubectl apply -f chain33-config.yaml
```  
 3.创建storageClass
 ```
   kubectl apply -f chain33-storageClass.yaml
``` 
 4.创建statefulSet
 ```
   kubectl apply -f chain33-statefulSet.yaml
``` 

## 观察pod拉起情况
```
   kubectl get pods
# 会查到有四个 chain-0 chain33-1 chain33-2  chain33-3 四个pod拉起
```

## 进入其中一个节点查看节点同步情况

```
   kubectl exec -it chain33-0 -- ./chain33-cli valnode nodes

   kubectl exec -it chain33-0 -- ./chain33-cli net is_sync
```
##  用测试工具向其中一个节点发送交易，并观察区块高度是否增长
```
  wget https://bty33.oss-cn-shanghai.aliyuncs.com/chain33Dev/sendtx-count
  
  chmod +x sendtx-count
  
  ./sendtx-count   put  [节点ip]  100 

```
