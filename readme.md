# Go - Rabbit MQ connector
Simple Go application for sending/reading messages to/from RabbitMQ.
## Requirements
Install Go, Docker, K3d, Kubectl, Helm
### Prepare environment 
```sh 
k3d cluster create
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install my-rabbitmq bitnami/rabbitmq --set auth.username=user,auth.password=PASSWORD
kubectl port-forward pods/my-rabbitmq-0 15672
```
Open localhost:15672. Create user with `management` tag for vhost `/` and create `classic` queue for vhos `/`.  
In this example:  
```sh
Queue: go-q  
User/Pass: go-u:go-u
```
## Code
Sourced infromation from https://www.rabbitmq.com/tutorials/tutorial-one-go.
```sh
go mod init <your-module-name>
go get github.com/rabbitmq/amqp091-go
```
Build and push the image.  
```sh
docker build -t simonliska/saturday:go-rabbit-latest .
docker push simonliska/saturday:go-rabbit-latest
```
Apply deployment to K3d, check status:
```sh 
kubectl apply -f sender-deployment.yaml -f reader-deployment.yaml
kubectl get pods -w
```
Check sender logs:
```sh 
kubectl logs -l app=sender
2024/04/28 16:38:03  [x] Sent Hello World!
2024/04/28 16:39:03  [x] Sent Hello World!
2024/04/28 16:40:03  [x] Sent Hello World!
```
Check reader logs:
```sh
kubectl logs -l app=reader
```
Nicely done!