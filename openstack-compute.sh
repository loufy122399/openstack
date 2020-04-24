#!/bin/bash

/usr/sbin/ntpdate time1.aliyun.com && hwclock  -w
echo '时间同步完成,时间：date +%Y-%m-%d-%H:%M:%S'
\cp /etc/sysctl.conf /etc/sysctl.conf
echo '参数优化'
echo "192.168.134.10 openstack-vip.lou.local" >> /etc/hosts
sleep 1

yum install centos-release-openstack-train.noarch -y
sleep 1
yum install python-openstackclient -y
sleep 1
yum install openstack-selinux -y 
sleep 1

#install nova
yum install openstack-nova-compute -y
sleep 1
tar xvf /etc/nova/nova-compute.tar.gz -C /etc/nova/
IP=`ifconfig bond0 | grep -w inet | awk '{print $2}'`
echo '当前IP是：${IP}'
sed -i 's/server_proxyclient_address = 192.168.134.100/server_proxyclient_address = ${IP}/g' /etc/nova/nova.conf

systemctl enable libvirtd.service openstack-nova-compute.service && systemctl start libvirtd.service openstack-nova-compute.service
 sleep 1

#install neutron

yum install openstack-neutron-linuxbridge ebtables ipset -y
sleep 1
tar xvf neutron-compute.tar.gz -C /etc/neutron/
\cp linuxbridge_neutron_agent.py /usr/lib/python2.7/site-packages/neutron/plugins/ml2/drivers/linuxbridge/agent/linuxbridge_neutron_agent.py
systemctl restart openstack-nova-compute.service 
sleep 1
systemctl enable neutron-linuxbridge-agent.service && systemctl start neutron-linuxbridge-agent.service
echo '当前节点nova和neutron配置完成'
echo 查看日志是否有报错，或在controller节点查找日志

sleep 5

#reboot节点
 
shutdown -r +1 "一分钟之后重启"
