# vagrant-sentinel

This is small  Redis playground created in Vagrant.  

To run haproxy, install `haproxy` package, enable haproxy to bind any TCP ports 
(`setsebool -P haproxy_connect_any 1`) and set-up haproxy.cfg 


```
defaults REDIS
 mode tcp
 timeout connect 4s
 timeout server  30s
 timeout client  30s

frontend ft_redis
 bind *:6380 name redis
 default_backend bk_redis
 
backend bk_redis
 option tcplog
 option tcp-check
 tcp-check send PING\r\n
 tcp-check expect string +PONG
 tcp-check send info\ replication\r\n
 tcp-check expect string role:master
 server R-left 192.168.11.101:6379 check inter 1s
 server R-right 192.168.11.102:6379 check inter 1s
 server R-center 192.168.11.103:6379 check inter 1s
```

The config is updated from
http://blog.haproxy.com/2014/01/02/haproxy-advanced-redis-health-check/