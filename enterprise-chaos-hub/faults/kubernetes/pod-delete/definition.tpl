apiVersion: litmuchaos.io/v1alpha2
kind: K8sFault
metadata:
  name: pod-delete
spec:
  definition:
    targets:
      selectors:
        workloads:
        - kind: "{{ .TARGET_WORKLOAD_KIND }}"
          namespace: "{{ .TARGET_WORKLOAD_NAMESPACE }}"
          names: "{{ .TARGET_WORKLOAD_NAMES }}"
          labels: "{{ .TARGET_WORKLOAD_LABELS }}"
    chaos:
      experiment: pod-delete
      image: harness/chaos-ddcr-faults:1.54.0
      imagePullPolicy: IfNotPresent
      env:
      - name: TOTAL_CHAOS_DURATION
        value: "{{ .TOTAL_CHAOS_DURATION }}"
      - name: CHAOS_INTERVAL
        value: "{{ .CHAOS_INTERVAL }}"
      - name: FORCE
        value: "{{ .FORCE }}"
      - name: RAMP_TIME
        value: "{{ .RAMP_TIME }}"
      - name: POD_AFFECTED_PERCENTAGE
        value: "{{ .POD_AFFECTED_PERCENTAGE }}"
      - name: TARGET_PODS
        value: "{{ .TARGET_PODS }}"
      - name: NODE_LABEL
        value: "{{ .NODE_LABEL }}"
      - name: SEQUENCE
        value: "{{ .SEQUENCE }}"
