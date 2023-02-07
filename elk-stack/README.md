# Install ELK Stack inside Gitops-Playground


The following will deploy a komplete ELK Stack inside gitops-playground.


#### Kibana

Kibana is reachable at URL
```
	http://localhost:9100
```


<br>

#### Elastic

Elastic 
	with 1 Maser, 1 Client and 1 data insatnce 
```
	http://elasticsearch-master.elasticsearch.svc.cluster.local:9200
```
only internal reachable ClusterIP

```
Elasticsearch credentials
username: elastic
password: admin
```

<br>

#### Logstash

logstash has two configured inputs
```
	beats http://localhost:9144
	tcp   http://localhost:9150
```



<br>

### Deploy / Install

First make shure gitops-playground is up and running, then
```
cd gitops-playground/elk-stack
make deploy

```


<br>

### Uninstall

```
make uninstall  =>   will uninstall, but leaves the namespace, pvc, role, rolebindings and secrets

make clean  => will purge all
```



### Test
Simple Test can be done with 
```
echo "Hello ELK"  | nc -4 localhost 9150
```
Then seach in Kibana for the string "Hello ELK"

### Jenkins Test
Install Plugin "Logstash"
Configuration can be done in two ways 
1. Of type "Logstash" and Logstash tcp input URL
2. Of type Elasticsearch and Logstash tcp URL with username/pasword
