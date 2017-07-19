apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: cluster-autoscaler
  namespace: kube-system
  labels:
    k8s-app: cluster-autoscaler
spec:
  replicas: 1
  template:
    metadata:
      labels:
        k8s-app: cluster-autoscaler
    spec:
      nodeName: ${node_name}
      containers:
        - image: gcr.io/google_containers/cluster-autoscaler:v0.5.4
          name: cluster-autoscaler
          resources:
            requests:
              cpu: 10m
              memory: 300Mi
          command:
            - ./cluster-autoscaler
            - --kubernetes=https://kubernetes.default
            - --nodes=1:5:https://www.googleapis.com/compute/v1/projects/${project_id}/zones/${gce_zone}/instanceGroups/${node_group}
            - --scale-down-enabled=true
            - --cloud-config=/var/lib/kubernetes/gce.conf
            - --cloud-provider=gce
          volumeMounts:
            - mountPath: /var/lib/kubernetes/gce.conf
              name: cloudconfigmount
              readOnly: true
            - name: ssl-certs
              mountPath: /etc/ssl/certs
              readOnly: true
            - name: usrsharecacerts
              mountPath: /usr/share/ca-certificates
              readOnly: true
          imagePullPolicy: "Always"
      volumes:
        - name: cloudconfigmount
          hostPath:
            path: "/var/lib/kubernetes/gce.conf"
        - name: ssl-certs
          hostPath:
            path: "/etc/ssl/certs"
        - name: usrsharecacerts
          hostPath:
            path: "/usr/share/ca-certificates"