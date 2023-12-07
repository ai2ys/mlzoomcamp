# homework


```bash
git clone https://github.com/DataTalksClub/machine-learning-zoomcamp.git

pushd machine-learning-zoomcamp/cohorts/2023/05-deployment/homework

docker build -t zoomcamp-model:hw10 .
docker run -it --rm -p 9696:9696 zoomcamp-model:hw10
```
Other terminal run
```bash
python q6_test.py
```
## q1
`0.7269`


Install kind Linux
```bash
# For AMD64 / x86_64
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
kind --version
```

## q2
`kind version 0.20.0`

Install kubectl
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

```
kind create cluster
kubectl cluster-info
```

```bash
kubectl get services
```

## q3
ClusterIP 10.96.0.1

```bash
kind load docker-image zoomcamp-model:hw10
```
## q4
`kind load docker-image`

```bash
kubectl apply -f deployment.yaml
```
## q5
`9696`

```bash
kubectl get pods
```

```bash
kubectl apply -f service.yaml
```
```bash
kubectl port-forward service/get-credit 9696:80
```