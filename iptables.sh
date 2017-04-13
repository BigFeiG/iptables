#!/bin/bash
#
#防火墙配置
#@yufei 20140310
#
#清除预设配置
/sbin/iptables -P INPUT ACCEPT
/sbin/iptables -F
/sbin/iptables -X
/etc/init.d/iptables save

#允许架构间服务器访问
/sbin/iptables -A INPUT -s 10.0.0.0 -j ACCEPT


#允许dns
/sbin/iptables -A FORWARD -p udp --dport 53 -j ACCEPT
/sbin/iptables -A INPUT -p udp --dport 53 -j ACCEPT
/sbin/iptables -A OUTPUT -p udp --sport 53 -j ACCEPT

#允许ntp时间同步
/sbin/iptables -A INPUT -p udp --dport 123 -j ACCEPT
/sbin/iptables -A OUTPUT -p udp --dport 123 -j ACCEPT

#允许回环口
/sbin/iptables -A INPUT -i lo -p all -j ACCEPT
/sbin/iptables -A OUTPUT -o lo -p all -j ACCEPT

#允许ping
#/sbin/iptables -A INPUT -p icmp -m limit --limit 1/s -j ACCEPT
#/sbin/iptables -A INPUT -p icmp -j LOG --log-level 4 --log-prefix "iptables_ping"
/sbin/iptables -A INPUT -p icmp -j ACCEPT
/sbin/iptables -A OUTPUT -p icmp -j ACCEPT

#允许连接状态 拒绝非法连接
/sbin/iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
/sbin/iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
/sbin/iptables -A INPUT -m state --state INVALID -j DROP
/sbin/iptables -A OUTPUT -m state --state INVALID -j DROP
/sbin/iptables -A FORWARD -m state --state INVALID -j DROP

#允许sshr
/sbin/iptables -A INPUT -s 117.71.48.0 -p tcp -m multiport --dport 22,8822 -j ACCEPT
/sbin/iptables -A INPUT -s 10.26.243.63 -p tcp -m multiport --dport 22,8822 -j ACCEPT
/sbin/iptables -A INPUT -p tcp -m multiport --dports 22,8822 -j LOG --log-level 4 --log-prefix "iptables_ssh"
/sbin/iptables -A INPUT -p tcp -m multiport --dport 22,8822 -j DROP

#允许ftp 
/sbin/iptables -A INPUT -s 117.71.48.0 -p tcp --dport 8021 -j ACCEPT
/sbin/iptables -I INPUT -s 117.71.48.0 -p tcp --dport 40000:40050 -j ACCEPT
/sbin/iptables -A INPUT -p tcp -m multiport --dports 8021,40000:40050 -j DROP

#允许rsync 
/sbin/iptables -A INPUT -s 10.0.0.0/8 -p tcp --dport 873 -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport 873 -j DROP

#允许snmpd & master
/sbin/iptables -A INPUT -s 10.0.0.0/8 -p udp --dport 161 -j ACCEPT
/sbin/iptables -A INPUT -s 10.0.0.0/8 -p tcp --dport 199 -j ACCEPT
/sbin/iptables -A INPUT -s 10.0.0.0/8 -p tcp --dport 25 -j ACCEPT
/sbin/iptables -A OUTPUT -p udp --dport 161 -j DROP

#web端口
/sbin/iptables -A INPUT -p tcp --dport 80 -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport 443 -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport 8233 -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport 8234 -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport 8235 -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport 8000 -j ACCEPT
/sbin/iptables -A INPUT -p udp --dport 9613 -j ACCEPT
/sbin/iptables -A INPUT -p udp --dport 9603 -j ACCEPT
/sbin/iptables -A INPUT -p udp --dport 9612 -j ACCEPT
/sbin/iptables -A INPUT -p udp --dport 9602 -j ACCEPT
/sbin/iptables -A INPUT -p udp --dport 9614 -j ACCEPT
/sbin/iptables -A INPUT -p udp --dport 9604 -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport 9801 -j ACCEPT

#网上客服
/sbin/iptables -A INPUT -s 127.0.0.1 -p tcp --dport 8002 -j ACCEPT
/sbin/iptables -A INPUT -s 10.26.241.12 -p tcp --dport 8002 -j ACCEPT
/sbin/iptables -A INPUT -p tcp --dport 8002 -j DROP

#mysql数据库
/sbin/iptables -A INPUT -p tcp --dport 3306 -j ACCEPT
/sbin/iptables -A OUTPUT -s 10.0.0.0/8 -p tcp --dport 3306 -j ACCEPT
/sbin/iptables -A OUTPUT -p tcp --dport 3306 -j ACCEPT
/sbin/iptables -A OUTPUT -p tcp --dport 3306 -j DROP

#memcache magent
/sbin/iptables -A INPUT -s 10.0.0.0/8 -p tcp --dport 11211 -j ACCEPT
/sbin/iptables -A INPUT -s 10.0.0.0/8 -p udp --dport 11211 -j ACCEPT

#nfs
 
#svn

#允许邮件

#阻止危险出口
/sbin/iptables -A OUTPUT -p tcp --sport 31337 -j DROP
/sbin/iptables -A OUTPUT -p tcp --dport 31337 -j DROP

#ID

#默认阻止所有端口
/sbin/iptables -P INPUT DROP
/sbin/iptables -P OUTPUT ACCEPT
/sbin/iptables -P FORWARD ACCEPT
/etc/init.d/iptables save
/etc/init.d/iptables restart