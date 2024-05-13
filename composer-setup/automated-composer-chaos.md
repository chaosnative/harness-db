# Running Node Drain Chaos Experiment on an Autopilot Cluster having Composer deployed

### Chaos Infrastructure Deployment
- Autopilot doesn't allow resources without minimum resources - 512Mi Memory & 250m CPU. So need to adjust the same in Chaos Infrastructure's manifest.

- Add permissions to list, get and patch the PDB's by experiment pods to `litmus-admin` cluster-role - 

```yaml
  - apiGroups: [ "policy" ]
    resources: [ "poddisruptionbudgets" ]
    verbs: [ "get", "list", "patch" ]
```

- Apply the configmap containing script to take backup of existing PDBs, patch them & then revert them back once chaos is completed - 
```bash
kubectl apply -f composer-scripts-cm.yaml -n <namespace of chaos infrastructure>
```

### Chaos Experiment Tuning

- Update your experiment to use above scripts & trigger them using probes - 
  - Add volume mount in chaos-engine under spec.experiments[0].spec.components.configMaps
  ```yaml
  spec:
    appinfo:
      appns: upgrade-test-2
      applabel: app=chaos-exporter
      appkind: deployment
    engineState: active
    chaosServiceAccount: litmus-admin
    experiments:
      - name: pod-delete
        spec:
          components:
          # Mounting the configmaps containing scripts
            configMaps:
              - name: composer-pre-post-scripts
                mountPath: /composer-pre-post-scripts
  ```

  - Add probes to trigger the scripts in SOT & EOT modes
  ```yaml
  # Running pre-script to patch PDBs to 0
  - name: pdb-update
    type: cmdProbe
    mode: SOT
    runProperties:
      probeTimeout: 180s
      retry: 0
      interval: 1s
      stopOnFailure: false
    cmdProbe/inputs:
      command: bash /composer-pre-post-scripts/pre-script.sh
      comparator:
        type: string
        criteria: contains
        value: Done
  # Running post-script to revert PDBs to actual values
  - name: pdb-revert
    type: cmdProbe
    mode: EOT
    runProperties:
      probeTimeout: 180s
      retry: 0
      interval: 1s
      stopOnFailure: false
    cmdProbe/inputs:
      command: bash /composer-pre-post-scripts/post-script.sh
      comparator:
        type: string
        criteria: contains
        value: Done
  ```

- Now you can run Node Drain experiments on an Autopilot cluster where composer/airflow is deployed.