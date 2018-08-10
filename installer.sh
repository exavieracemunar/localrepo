# !/bin/sh
# Description: Installation of packages
# Author: SysAdTrainee (toro.exavierace.munar@gmail.com)
# install nginx
    if rpm -qa --quiet nginx;then
     echo "[ INFO ] Nginx was installed."
    else 
     echo "[ INFO ] Nginx was not installed."
     echo "[ INFO ] Installing Nginx.."
     sudo rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
     sudo yum install -y nginx
    fi
# install tomcat
    if  rpm -qa --quiet tomcat;then
     echo "[ INFO ] Tomcat was installed."
    else 
     echo "[ INFO ] Tomcat was not installed."
     echo "[ INFO ] Installing Tomcat.."
     sudo yum install -y tomcat
    fi
# install java
    if  rpm -qa --quiet java;then
     echo "[ INFO ] Java was installed."
    else 
     echo "[ INFO ] Java was not installed."
     echo "[ INFO ] Installing Java.."
     sudo yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel
    fi
# install mysql
    if  rpm -qa --quiet mysql;then
     echo "[ INFO ] Mysql was installed."
    else 
     echo "[ INFO ] Mysql was not installed."
     echo "[ INFO ] Installing Mysql.."
     sudo yum install -y mysql-server
    fi
