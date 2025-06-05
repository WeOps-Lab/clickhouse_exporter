apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: clickhouse-exporter-{{VERSION}}
  namespace: clickhouse
spec:
  serviceName: clickhouse-exporter-{{VERSION}}
  replicas: 1
  selector:
    matchLabels:
      app: clickhouse-exporter-{{VERSION}}
  template:
    metadata:
      annotations:
        telegraf.influxdata.com/interval: 1s
        telegraf.influxdata.com/inputs: |+
          [[inputs.cpu]]
            percpu = false
            totalcpu = true
            collect_cpu_time = true
            report_active = true

          [[inputs.disk]]
            ignore_fs = ["tmpfs", "devtmpfs", "devfs", "iso9660", "overlay", "aufs", "squashfs"]

          [[inputs.diskio]]

          [[inputs.kernel]]

          [[inputs.mem]]

          [[inputs.processes]]

          [[inputs.system]]
            fielddrop = ["uptime_format"]

          [[inputs.net]]
            ignore_protocol_stats = true

          [[inputs.procstat]]
          ## pattern as argument for pgrep (ie, pgrep -f <pattern>)
            pattern = "exporter"
        telegraf.influxdata.com/class: opentsdb
        telegraf.influxdata.com/env-fieldref-NAMESPACE: metadata.namespace
        telegraf.influxdata.com/limits-cpu: '300m'
        telegraf.influxdata.com/limits-memory: '300Mi'
      labels:
        app: clickhouse-exporter-{{VERSION}}
        exporter_object: clickhouse
        object_version: {{VERSION}}
        pod_type: exporter
    spec:
      nodeSelector:
        node-role: worker
      shareProcessNamespace: true
      containers:
      - name: clickhouse-exporter-{{VERSION}}
        image: registry-svc:25000/library/clickhouse-exporter:latest
        imagePullPolicy: Always
        args:
        - --clickhouse_only
        - --scrape_uri=http://clickhouse-{{VERSION}}.clickhouse:8123

        env:
        - name: CLICKHOUSE_USER
          value: admin

        - name: CLICKHOUSE_PASSWORD
          value: weops@1#2!

        securityContext:
          allowPrivilegeEscalation: false
          runAsUser: 0
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
          limits:
            cpu: 1000m
            memory: 300Mi
        ports:
        - containerPort: 9116

---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: clickhouse-exporter-{{VERSION}}
  name: clickhouse-exporter-{{VERSION}}
  namespace: clickhouse
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "9116"
    prometheus.io/path: '/metrics'
spec:
  ports:
  - port: 9116
    protocol: TCP
    targetPort: 9116
  selector:
    app: clickhouse-exporter-{{VERSION}}
