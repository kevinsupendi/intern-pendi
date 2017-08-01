### Prerequisites :

- Docker (build image) [link](https://www.docker.com/get-docker)

- gcloud command line tools (push image) [link](https://cloud.google.com/container-engine/docs/tutorials/hello-node)


### Demo

0. Setup kubernetes dengan Terraform di terraform/gce

1. Warm-up
	- kubectl version
	- kubectl get nodes
	- kubectl get pods
	- kubectl -n kube-system get pods
	- kubectl get svc
	- kubectl -n kube-system get svc
	- kubectl get deployments
	- kubectl -n kube-system get deployments

2. Deploy
	- Deploy nodejs app, mulai dari build, push image, dan deploy di kubernetes

	- Edit server.js, ubah kata-kata yang akan diprint

	```
	docker build -t gcr.io/intern-kevin/hello-node:v1 .
	gcloud docker -- push gcr.io/intern-kevin/hello-node:v1
	```	

	- Edit server.js, ubah kata-kata yang akan diprint
	
	```
	docker build -t gcr.io/intern-kevin/hello-node:v2 .
	gcloud docker -- push gcr.io/intern-kevin/hello-node:v2
	```

	Sekarang akan ada 2 versi image di GCP container registry
	
	- Deploy v1 dengan 1 replica

	```
	kubectl run hello --image=gcr.io/intern-kevin/hello-node:v1 --port=80
	```

	- App belum bisa diakses dari luar tanpa Service, expose dengan tipe LoadBalancer

	```
	kubectl expose deployment hello --type=LoadBalancer
	```
	- Dapatkan Pod name

	```
	kubectl get pods
	kubectl get svc
	```

	- Buka di web browser dan akses external IP, pastikan bisa diakses

3. Self Healing

	- Delete pod dengan pod name

	```
	kubectl delete pod hello-xxxx
	```

	- Refresh web browser untuk melihat bahwa hostname telah berubah ke pod lain

4. Service discovery & Load Balancing

	- Tambahkan pod replica menjadi 3

	```
	kubectl scale deployment hello --replicas=3
	```

	- Refresh di web browser dan lihat bahwa ada perubahan hostname, mengindikasikan adanya Load Balancing antar Pod

5. Rolling update & Rollback

	- Lakukan rolling update, tetapi sengaja memberikan typo

	```
	kubectl set image deployment/hello hello=gcr.io/intern-kevin/hello-mode:v2
	```

	- Tunjukkan bahwa meskipun image salah, aplikasi v1 tetap berjalan di web
	- Cek pod dan rollout status

	```
	kubectl get pods
	kubectl get deployment
	kubectl rollout status deployment hello
	```
	Ctrl^C untuk menghentikan rollout status

	- Lakukan rollback

	```
	kubectl rollout undo deployment hello
	kubectl rollout status deployment hello
	kubectl get pods
	```

	- Rolling update dengan image yang benar

	```
	kubectl set image deployment/hello hello=gcr.io/intern-kevin/hello-node:v2
	kubectl get pods
	```

	- Refresh untuk melihat pesan versi 2 telah diprint

6. Secrets

	- Buat secret untuk MySQL root password

	```
	kubectl create secret generic mysql-root-pass --from-literal=root='inibukandefaultpass'
	```

	Kemudian copy file mysql.yaml dan deploy ke Kubernetes.
	Lalu login ke dalam container.

	```
	kubectl apply -f mysql.yaml
	kubectl get pods
	kubectl exec -it mysql-xxx -- bash
	```
	
	- Login ke mysql dengan password dari secret yang telah dibuat

	```
	mysql -u root -p
	```

7. Autoscaling

	- Deploy aplikasi apache dan autoscale

	```
	kubectl run php-apache --image=gcr.io/google_containers/hpa-example --requests=cpu=200m --expose --port=80
	kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10
	kubectl get hpa
	```

	- Buat load generator menggunakan busybox dengan terminal lain

	```
	kubectl run -it busy --image=busybox /bin/sh
	while true; do wget -q -O- http://php-apache.default; done	
	```
	
	- Cek hpa sesekali untuk melihat apakah deployment telah discale-up, jika test selesai, Ctrl-C Busybox.

	```
	kubectl get hpa
	```

	HPA akan melakukan scale down dalam waktu 5 menit.

	- Deploy 120 pod nginx untuk menguji Cluster Autoscaler

	```
	kubectl run nginx --image=nginx --replicas=120
	```
	
	Lihat di Cloud Console node sudah bertambah.
	CA akan melakukan scale down dalam waktu 10 menit

8. Clean up

	```
	kubectl delete --all deployment --namespace=default
	kubectl delete --all svc --namespace=default
	kubectl delete hpa php-apache
	```