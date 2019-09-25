# devops-casestudy-one
Google cloud shell

# Clone the github repo containing nginx nodejs app 
$ git clone https://github.com/mrvrbabu/devops-casestudy-one 

# Build docker image and push to gcr repo 
$ docker build -t eu.gcr.io/${PROJECT_ID}/devops-casestudy-one:v1 . 
$ docker push eu.gcr.io/${PROJECT_ID}/devops-casestudy-one:v1 


# Create kubernetes deployment with image from google registry ensure you have access to the repo 
$ kubectl create deployment devops-casestudy-deployment --image=eu.gcr.io/prod-architecture/devops-casestudy-one:v1

# Create service to access the deployment 
$ kubectl expose deployment devops-casestudy-service  --type=LoadBalancer --port 81 --target-port 8080



Docker 
# Clone repo on to local system 
$ git clone https://github.com/mrvrbabu/devops-casestudy-one 

# Build docker image 
$  docker build -t vrbabu/devops-casestudy-one:nodenginx01 .

# Login to docker hub 
$ docker login 

# Push image to docker hub 
$ docker push vrbabu/devops-casestudy-one:nodenginx01

# Run containers by pulling image from docker hub (docker.io/vrbabu/devops-casestudy-one:nodenginx01)
$ docker run -it -p 8081:8080 vrbabu/devops-casestudy-one:nodenginx01 

# Create docker hub credentials to pull and deploy image from docker hub 
$ kubectl create secret docker-registry regicred --docker-server=docker.io --docker-username=vrbabu --docker-password=samplepassword --docker-email='mr.vrbabu@hotmail.com'

# Sample yaml file for deployment 
---
apiVersion: v1
kind: Pod
metadata:
  name: devops-casestudy
spec:
  containers:
  - name: nodenginx01
    image: docker.io/vrbabu/devops-casestudy-one:nodenginx01
    ports:
    - containerPort: 8080
  imagePullSecrets:
    - name: regicred

# Sample yaml file for service 
---
apiVersion: v1
kind: Service
metadata:
  name: my-nodenginx
  labels:
    run: my-nodenginx
spec:
  ports:
  - port: 80
    protocol: TCP
  selector:
    run: my-nodenginx
    
