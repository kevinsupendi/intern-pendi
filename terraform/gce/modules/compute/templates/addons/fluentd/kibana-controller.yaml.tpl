apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: kibana-logging
  namespace: kube-system
  labels:
    k8s-app: kibana-logging
    kubernetes.io/cluster-service: "true"
    addonmanager.kubernetes.io/mode: Reconcile
spec:
  replicas: 1
  selector:
    matchLabels:
      k8s-app: kibana-logging
  template:
    metadata:
      labels:
        k8s-app: kibana-logging
    spec:
      nodeName: ${node_name}
      containers:
      - name: kibana-logging
        image: gcr.io/google_containers/kibana:v4.6.1-1
        resources:
          # keep request = limit to keep this container in guaranteed class
          limits:
            cpu: 100m
          requests:
            cpu: 100m
        env:
          - name: "ELASTICSEARCH_URL"
            value: "http://elasticsearch-logging.kube-system.svc.cluster.local:9200"
          - name: "KIBANA_BASE_URL"
            value: "/kibana"
        ports:
        - containerPort: 5601
          name: ui
          protocol: TCP