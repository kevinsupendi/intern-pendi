apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: kube-dns
  namespace: kube-system
  labels:
    app: kubedns
spec:
  replicas: 1
  selector:
   matchLabels:
     app: kubedns
  template:
    metadata:
      labels:
        app: kubedns
    spec:
      tolerations: 
      - key: "node"
        operator: "Equal"
        value: "master"
        effect: "NoSchedule"
      nodeSelector:
        node: master
      volumes:
      - name: "kubeconfig"
        hostPath:
          path: "/var/lib/kubelet/"
      - name: "kubecerts"
        hostPath:
          path: "/var/lib/kubernetes/"
      containers:
      - name: kubedns
        volumeMounts:
        - name: "kubeconfig"
          mountPath: "/var/lib/kubelet/"
          readOnly: true
        - name: "kubecerts"
          mountPath: "/var/lib/kubernetes/"
          readOnly: true
        image: gcr.io/google_containers/kubedns-amd64:1.8
        resources:
          limits:
            memory: 170Mi
          requests:
            cpu: 100m
            memory: 70Mi
        livenessProbe:
          httpGet:
            path: /healthz-kubedns
            port: 8080
            scheme: HTTP
          initialDelaySeconds: 60
          timeoutSeconds: 5
          successThreshold: 1
          failureThreshold: 5
        readinessProbe:
          httpGet:
            path: /readiness
            port: 8081
            scheme: HTTP
          initialDelaySeconds: 3
          timeoutSeconds: 5
        args:
        - --kubecfg-file=/var/lib/kubelet/kubeconfig
        - --domain=cluster.local.
        - --dns-port=10053
        ports:
        - containerPort: 10053
          name: dns-local
          protocol: UDP
        - containerPort: 10053
          name: dns-tcp-local
          protocol: TCP
      - name: dnsmasq
        volumeMounts:
        - name: "kubeconfig"
          mountPath: "/var/lib/kubelet/"
          readOnly: true
        - name: "kubecerts"
          mountPath: "/var/lib/kubernetes/"
          readOnly: true
        image: gcr.io/google_containers/kube-dnsmasq-amd64:1.4
        livenessProbe:
          httpGet:
            path: /healthz-dnsmasq
            port: 8080
            scheme: HTTP
          initialDelaySeconds: 60
          timeoutSeconds: 5
          successThreshold: 1
          failureThreshold: 5
        args:
        - --cache-size=1000
        - --no-resolv
        - --server=127.0.0.1#10053
        - --log-facility=-
        ports:
        - containerPort: 53
          name: dns
          protocol: UDP
        - containerPort: 53
          name: dns-tcp
          protocol: TCP
      - name: healthz
        volumeMounts:
        - name: "kubeconfig"
          mountPath: "/var/lib/kubelet/"
          readOnly: true
        - name: "kubecerts"
          mountPath: "/var/lib/kubernetes/"
          readOnly: true
        image: gcr.io/google_containers/exechealthz-amd64:1.2
        resources:
          limits:
            memory: 50Mi
          requests:
            cpu: 10m
            memory: 50Mi
        args:
        - --cmd=nslookup kubernetes.default.svc.cluster.local 127.0.0.1 >/dev/null
        - --url=/healthz-dnsmasq
        - --cmd=nslookup kubernetes.default.svc.cluster.local 127.0.0.1:10053 >/dev/null
        - --url=/healthz-kubedns
        - --port=8080
        - --quiet
        ports:
        - containerPort: 8080
          protocol: TCP
      dnsPolicy: Default

---

apiVersion: v1
kind: Service
metadata:
  name: kube-dns
  namespace: kube-system
  labels:
    app: kubedns
spec:
  selector:
     app: kubedns
  clusterIP: ${cluster_ip}
  ports:
  - name: dns
    port: 53
    protocol: UDP
  - name: dns-tcp
    port: 53
    protocol: TCP