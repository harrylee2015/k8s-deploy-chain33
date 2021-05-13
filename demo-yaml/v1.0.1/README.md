# k8s-deploy-chain33 手动在k8s上面部署chain33测试操作流程

## 前提
  有一套完好的k8s测试环境

## 1. chain33镜像制作
   ```
      docker build  -t chain33:v1.0.1  .
   ```
## 2. 选择要部署的kubelet节点,手动挂载配置文件(可以酌情自己修改chain33中得相关配置)
   ```
      登录到kubelet节点，进入shell会话
      mkdir /chain33   将chain33下面的文件夹mv 到 /chain33下面
      使用minkube直接用docker 拷贝
      docker cp chain33    minkube:/
   ```
## 3. 部署服务
    
   ```
      kubectl apply -f  yaml/
   ```
## 问题记录
   v1.0.1 主要用来开发和测试k8s中能否部署chain33,配置文件，数据卷都是主机映射挂载的，不具备生产环境部署的能力，后面这一问题我将放在下一个版本中去解决
   
   序号|问题
   ------|------
   1|配置文件和数据卷挂载问题
   2|联盟链创世私钥脚本需要动态生成
   3|联盟链节点扩容（暂不支持缩容）
   4|每一条链采用StatefulSet 资源定义方式创建
