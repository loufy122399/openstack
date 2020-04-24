yum install centos-release-openstack-train.noarch -y
yum install python-openstackclient -y
yum install openstack-selinux
yum install python2-PyMySQL 
yum install python-memcached -y
yum install openstack-keystone httpd mod_wsgi -y
/etc/hosts 域名
cd /etc/keystone/
tar czvf keystone-controller.tar.gz ./*
vim /etc/httpd/conf/httpd.conf
ServerName 本地地址:80
ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/
systemctl enable httpd.service
systemctl start httpd.service
验证：
HAproxy换IP看是否通

#glance 
yum install openstack-glance
NFS挂载过来：配置和controller1一样（注意权限）
controller-1:scp /etc/glance/glance-controller.tar.gz 192.168.134.201:/etc/glance
grep 192 ./* -R
#placement
yum install openstack-placement-api -y
cd /etc/placement/
tar czvf placement-controller1.tar.gz 192.168.134.201/enable/placement
tar xvf  placement-controller1.tar.gz
grep 192 ./* -R
#bug
scp /etc/httpd/conf.d/00-placement-api.conf 192.168.134.201:/etc/httpd/conf.d/00-placement-api.conf
systemctl restart httpd
tailf /var/log/placement/placement.api(8778)
#nova
yum install openstack-nova-api openstack-nova-conductor \
  openstack-nova-novncproxy openstack-nova-scheduler
  cd /etc/nova
  tar czvf nova-controller1.tar.gz 192.168.134.201:/etc/nova
  grep 192 ./* -R(修改)
    systemctl enable \
    openstack-nova-api.service \
    openstack-nova-scheduler.service \
    openstack-nova-conductor.service \
    openstack-nova-novncproxy.service
    systemctl start \
    openstack-nova-api.service \
    openstack-nova-scheduler.service \
    openstack-nova-conductor.service \
    openstack-nova-novncproxy.service
#neutron
yum install openstack-neutron openstack-neutron-ml2 \
  openstack-neutron-linuxbridge ebtables
   cd /etc/neutron
   tar czvf neutron-controller1.tar.gz 
   scp neutron-controller1.tar.gz 192.168.134.201:/etc/neutron
    tar xvf neutron-controller1.tar.gz
    grep 192 ./* -R
    systemctl restart openstack-nova-api.service

    systemctl enable neutron-server.service \
  neutron-linuxbridge-agent.service neutron-dhcp-agent.service \
  neutron-metadata-agent.service
systemctl start neutron-server.service \
  neutron-linuxbridge-agent.service neutron-dhcp-agent.service \
  neutron-metadata-agent.service
  #dashborad
  yum install openstack-dashboard
/etc/openstack-dashboard/
tar czvf dashboard-controller1.tar.gz 
scp dashboard-controller1.tar.gz  192.168.134.201:/etc/openstack-dashboard/
 tar xvf  dashboard-controller1.tar.gz
 grep 192 ./* -R(修改)
 systemctl restart httpd.service 
