### Prerequisites :

- Docker (build image) [link](https://www.docker.com/get-docker)

- gcloud command line tools (push image) [link](https://cloud.google.com/container-engine/docs/tutorials/hello-node)

### Demo

1. Setup kubernetes with Terraform in folder terraform/gce. See Quickstart for more details

2. Warm-up
	- kubectl version
	- kubectl get nodes
	- kubectl get pods
	- kubectl -n kube-system get pods
	- kubectl get svc
	- kubectl -n kube-system get svc
	- kubectl get deployments
	- kubectl -n kube-system get deployments

3. Set the project ID environment variable with your project ID

	```
	PROJECT_ID="intern-kevin"
	```

4. Deploy

	- Deploy nodejs app, start from building image, pushing, and deployment

	- Edit server.js file, change the hello message for version 1

	```
	docker build -t gcr.io/${PROJECT_ID}/hello-node:v1 .
	gcloud docker -- push gcr.io/${PROJECT_ID}/hello-node:v1
	```	

	- Edit server.js, change the hello message for version 2
	
	```
	docker build -t gcr.io/${PROJECT_ID}/hello-node:v2 .
	gcloud docker -- push gcr.io/${PROJECT_ID}/hello-node:v2
	```

	Now there will be 2 images in Google Container Registry
	
	- Deploy v1 app with 1 replica

	```
	kubectl run hello --image=gcr.io/${PROJECT_ID}/hello-node:v1 --port=80
	```

	- Pod is not accessible yet, expose the service with the type LoadBalancer

	```
	kubectl expose deployment hello --type=LoadBalancer
	```
	- Get Pod name

	```
	kubectl get pods
	kubectl get svc
	```

	- Access the service through your web browser with the external IP. Make sure it is working correctly

5. Self Healing

	- Delete pod

	```
	kubectl delete pod hello-xxxx
	```

	- Refresh web browser to see that the hostname has changed because the previous pod has gone

6. Service discovery & Load Balancing

	- Scale Pod replicas to 3

	```
	kubectl scale deployment hello --replicas=3
	```

	- Refresh web browser and see the changes on hostname, it means the pod's load balancer is working

	- Run a busybox pod and sh into it

	```
	kubectl run -it busy --image=busybox -- sh	
	```

	- Access another service by service name, not by IP

	```
	wget http://hello.default
	nslookup hello.default
	```

7. Rolling update & Rollback

	- Do a rolling update, but make a typo deliberately

	```
	kubectl set image deployment/hello hello=gcr.io/${PROJECT_ID}/hello-mode:v2
	```

	- Refresh web browser to show that the app still works with v1
	- Check pod and rollout status

	```
	kubectl get pods
	kubectl get deployment
	kubectl rollout status deployment hello
	```
	Ctrl-C to stop rollout status

	- Do a rollback

	```
	kubectl rollout undo deployment hello
	kubectl rollout status deployment hello
	kubectl get pods
	```

	- Rolling update with the correct image

	```
	kubectl set image deployment/hello hello=gcr.io/${PROJECT_ID}/hello-node:v2
	kubectl get pods
	```

	- Refresh to see that version 2 message is printed

8. Secrets

	- Create secret. This secret will be used as Environment Variable and files

	```
	kubectl create secret generic testsecret --from-literal=rahasiasaya='inirahasia'
	```

	Copy envsecret.yaml to VM. Deploy the file then login to Pod

	```
	kubectl apply -f envsecret.yaml
	kubectl get pods
	kubectl exec -it envbusy-xxx -- sh
	```
	
	- Print environment variable

	```
	echo $SECRETFROMKUBE
	```

	Copy filesecret.yaml to VM. Deploy the file then login to Pod

	```
	kubectl apply -f filesecret.yaml
	kubectl get pods
	kubectl exec -it filebusy-xxx -- sh
	```
	
	- Print file content

	```
	cat /etc/secretgue/
	```
	

9. Autoscaling

	- Deploy apache app and autoscale it

	```
	kubectl run php-apache --image=gcr.io/google_containers/hpa-example --requests=cpu=200m --expose --port=80
	kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10
	kubectl get hpa
	```

	- Open another terminal to create load generator from busybox image

	```
	kubectl run -it busy --image=busybox /bin/sh
	while true; do wget -q -O- http://php-apache.default; done	
	```
	
	- Cek hpa every minute to see if deployment has been scaled-up, if you're done with testing, Ctrl-C Busybox.

	```
	kubectl get hpa
	```

	HPA will scale down in 5 minutes.

	- Schedule HPA scale up with CronJob and demonstrate Cluster Autoscaler
	- Copy cronjob.yml to VM and apply it

	```
	kubectl apply -f cronjob.yml
	```
	Wait for 3 minutes

	- Check if cronjob has been activated

	```
	kubectl get cronjob
	```
	- Delete cronjob

	```
	kubectl delete cronjob update-hpa
	```

	Check in Cloud Console to see new nodes.
	CA will scale down in 10 minutes

10. Clean up

	```
	kubectl delete --all deployment --namespace=default
	kubectl delete --all svc --namespace=default
	kubectl delete hpa php-apache
	```