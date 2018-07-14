---
title: "Docker"
author: "hxd"
---


# 今日学习
- docker常用命令
- dockerfile
- dockercompose

### Docker
常用的命令

```
docker pull      拉取一个镜像
docker kill      杀死一个docker进程
docker images    列出所有镜像
docker push      把镜像提交
docker tag 		 给镜像打上标签
docker run       运行一个镜像
docker ps        列出正在运行的docker进程
```
比如：
```
下载镜像
docker pull registry.saas.handchina.com/tools/mysql:latest


镜像创建容器
docker@hand-mirror:~$ docker create -it 9546ca122d3a

设置标签
docker@hand-mirror:~$ docker tag registry.saas.hand-china.com/tools/mysql mysqltest


启动MySQL容器
docker@hand-mirror:~$ docker run --name mysqlserver -e MYSQL_ROOT_PASSWORD=123456 -d -i -p 3306:3306  9546ca122d3a

查看运行的容器：
docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
33d6e08797d0        9546ca122d3a        "docker-entrypoint.s…"   17 minutes ago      Up 17 minutes       0.0.0.0:3306->3306/tcp   mysqlserver

c8fe6f1b2c11        5766334bdaa0        "nginx -g 'daemon of…"   About an hour ago   Up About an hour    80/tcp, 443/tcp          elated_fermi


进入MySQL终端
docker@hand-mirror:~$ docker exec -it 33d6e08797d066f2ace07908dad3a104837e0ea4300fcf299bb753d920ba05d2 /bin/bash
root@33d6e08797d0:/# ls
bin   docker-entrypoint-initdb.d  home   media  proc  sbin  tmp
boot  entrypoint.sh               lib    mnt    root  srv   usr
dev   etc                         lib64  opt    run   sys   var

停止容器：
docker@hand-mirror:~$ docker stop 33d6e08797d0


删除容器：
docker@hand-mirror:~$ docker rm 33d6e08797d0

docker@hand-mirror:~$ docker container ls
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
c8fe6f1b2c11        5766334bdaa0        "nginx -g 'daemon of…"   About an hour ago   Up About an hour    80/tcp, 443/tcp     elated_fermi

提交一个镜像：
docker@hand-mirror:~$ docker commit mysqlserver

```

docker create命令能够基于镜像创建容器。
该命令执行的效果类似于docker run -d，即创建一个将在系统后台运行的容器。
但是与docker run -d不同的是，docker create创建的容器并未实际启动，还需要执行docker start命令或docker run命令以启动容器。
事实上，docker create命令常用于在启动容器之前进行必要的设置。

## Docker-compose
Compose 通过一个配置文件来管理多个Docker容器，在配置文件中，所有的容器通过services来定义，然后使用docker-compose脚本来启动，停止和重启应用，和应用中的服务以及所有依赖服务的容器，非常适合组合使用多个容器进行开发的场景.
基本命令：
```
$ alias dc=docker-compose(设置别名)
$ dc build 命令用来创建或重新创建服务使用的镜像
$ dc kill 命令用于通过向容器发送SIGKILL信号强行停止服务
$ dc logs 命令用于展示service的日志
$ dc pause 暂停服务
$ dc unpause 恢复被暂停的服务
$ dc port 命令用于查看服务中的端口被映射到了宿主机的哪个端口上，使用这条命令时必须通知指定服务名称和内部端口号
$ dc ps 用于显示当前项目下的容器
$ dc pull 用于拉取服务依赖的镜像
$ dc restart 用于重启某个服务的所有容器，后跟服务名
$ dc run 命令用于在服务中运行一个一次性的命令。使用这个命令会新建一个容器，其配置和service的配置一样，也就是说新建的容器和service启动的容器有相同的volumes，links等
$ dc start命令启动运行某个服务的所有容器
$ dc stop命令停止运行一个服务的所有容器
$ dc up 创建并运行作为服务的容器，并将其输入输出重定向到控制台(attach)，并将所有容器的输出合并到一起。命令退出后，所有的容器都会停止
如果--link依赖的容器没有运行则运行依赖的容器； 
-d标识指定容器后台运行
如果已经存在服务的容器，且容器创建后服务的配置有变化，就重新创建容器。如果没有变化，默认不会重新创建容器
--force-recreate标识指定即使服务配置没有变化，也重新创建容器； 
--no-recreate标识表示如果服务的容器已经存在，不要重新创建它们；
```
新建一个docker-compose.yml文件：集合了一个nginx和mysql还有一个hello镜像。

```
version: "3"
services:
  nginx:
    image: "103249542274"
    ports: 
      - "8080:80"
  hello:
    image: "2cb0d9787c4d"
  mysql: 
    image: "15a5ee56ec55"
    ports:
      - "3306:3306"
    restart: always
    environment:
        - MYSQL_DATABASE=demodb
        - MYSQL_ROOT_PASSWORD=123456
```
从docker-compose.yml文件看文件的构成和语法：
**image：**指定的镜像名或者镜像ID。如果在本地不存在该镜像，compose将会尝试区pull这个镜像。
**bulid：**指定Dockerfile所在文件夹的路径。	Compose		将会利用它自动构建这个镜像，然后使用这 个镜像。
**command：**覆盖容器后默认执行的命令。
**links：**链接到其它服务中的容器。使用服务名称（同时作为别名）或服务名称：服务别名	（SERVICE:ALIAS）		格式都可以。
**ports：**暴露端口信息。
不止以上端口。
### 总结
compose通过该文件来组织多个容器，使之能够便捷的搭建一个功能强大的服务。
如何理解docker-compose编排容器呢。例如，有一个php镜像，一个mysql镜像，一个nginx镜像。如果没有docker-compose，那么每次启动的时候，我们需要敲各个容器的启动参数，环境变量，容器命名，指定不同容器的链接参数等等一系列的操作，相当繁琐。而用了docker-composer之后，就可以把这些命令一次性写在docker-composer.yml文件中，以后每次启动这一整个环境（含3个容器）的时候，你只要敲一个docker-composer up命令就ok了。
docker-composer.yml 文件里的build命令有时会使用Dockerfile文件来构建镜像，这个特点就是Dockerfile和docker-compose.yml的联系。

[Git题目详解](https://mangoqiqi.github.io/2018/07/13/Git%E8%AF%95%E9%A2%98/) 持续更新...