# k8s-deploy-chain33
k8s-deploy-chain33 编写在k8s部署chain33所需要相关服务编排

## 版本规划

版本|功能 |完成时间
---|----|----
v1.0.1|支持手动部署svc,pod服务,配置文件需要手动节点挂载映射|2021.5.8
v1.0.2|配置文件采用configMap资源定义方式,磁盘采用PersistentVolume资源定义方式存储，使用StatefulSet来定义服务|2021.5.14
v1.0.3|采用go api进行资源部署|


## v1.0.2脚本部署

  **前提条件**

    执行脚本的节点安装了kubectl工具，且配置了相应的环境变量
    
**检测kubectl是否安装**
    
```
kubectl version
```
  **执行安装脚本**  
```
 cd scripts
 
 bash deploy.sh  <集群名称>  <副本数>  <部署目录>
 
 eg:
 
 bash deploy.sh  chain33    4   baas
 
 # 表示部署一个chain33的联盟链集群服务，总共有四个节点，安装在于当前脚本同级的baas文件夹下
```

