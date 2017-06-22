Ada satu aplikasi yang mau dideploy secara continous ke Kubernetes.

Syarat :
- Ada source code repository (misal Github)
- Menggunakan Docker dan Dockerfile 
- Docker image disimpan di cloud (misal Google Container Registry atau Docker Hub)

Caranya :
1. Buat .yaml file utk deployment dan service, pada tahap ini pastikan aplikasi bisa bekerja di kubernetes cluster
2. Buat job baru,pipeline, arahkan Jenkins ke scm yang diinginkan, atur credentials yang diperlukan untuk scm dan docker registry
3. Buat Jenkinsfile untuk : 
	3.1 checkout scm
	3.2 pull docker image
	3.3 lalu edit .yaml file dengan docker image yang baru