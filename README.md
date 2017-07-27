# ab
Ab docker container with some ip tools for using with openvswitch

Run containers and add ovs port to it  
```sh
for i in `seq 0 9`;do 
docker run -d -P -it --name=bomb$i --privileged -c 0 --cap-add NET_ADMIN --net=none zkryakgul/ubuntu /bin/bash && \
ovs-docker add-port br0 eth0 bomb$i --ipaddress=10.10.10.$(($i+50))/24 && \
docker exec -d -it bomb$i /sbin/ethtool -K eth0 tx off rx off 
done
```
start ab
```sh
for i in `seq 0 9`;do 
	docker exec -d -it bomb$i sh -c "/usr/bin/ab -c 16 -n 900000 -k http://10.10.10.6:8080/?hello.c > /usr/output 2>&1 "
done
```

delete ports and containers
```sh
for i in `seq 0 9`;do ovs-docker del-port br0 eth0 bomb$i && docker rm -f bomb$i ;done
```

show log files
```sh
for i in `seq 0 9`;do docker exec -it bomb$i /bin/cat /usr/output ;done
```
show total req per second
```sh
for i in `seq 0 9`;do docker exec -it bomb$i /bin/cat /usr/output ;done|grep "Requests per second"|awk 'BEGIN {FS=" "}{print $4}'|paste -sd+ |bc
```
