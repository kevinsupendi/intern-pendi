apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kube-system
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kubernetes-dashboard
  template:
    metadata:
      labels:
        app: kubernetes-dashboard
    spec:
      nodeName: ${node_name}
      containers:
      - name: kubernetes-dashboard
        image: gcr.io/google_containers/kubernetes-dashboard-amd64:v1.6.0
        imagePullPolicy: Always
        ports:
        - containerPort: 9090
          protocol: TCP
        volumeMounts:
        - name: "kubeconfig"
          mountPath: "/var/lib/kubelet/"
          readOnly: true
        - name: "kubecerts"
          mountPath: "/var/lib/kubernetes/"
          readOnly: true
        args:
          - --kubeconfig=/var/lib/kubelet/kubeconfig
          - --heapster-host=http://heapster.kube-system.svc.cluster.local
        livenessProbe:
          httpGet:
            path: /
            port: 9090
          initialDelaySeconds: 30
          timeoutSeconds: 30
      volumes:
      - name: "kubeconfig"
        hostPath:
          path: "/var/lib/kubelet/"
      - name: "kubecerts"
        hostPath:
          path: "/var/lib/kubernetes/"
---
kind: Service
apiVersion: v1
metadata:
  labels:
    app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kube-system
spec:
  ports:
  - port: 80
    targetPort: 9090
  selector:
    app: kubernetes-dashboard