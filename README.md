# Harness-DB

**List of Images required for HCE Installation**

```BASH
chaosnative/chaos-exporter:2.8.0
chaosnative/go-runner:2.8.0
chaosnative/chaos-runner:2.8.0
chaosnative/hce-auth-server:2.8.0
chaosnative/hce-event-tracker:2.8.0
chaosnative/hce-frontend:2.8.0
chaosnative/hce-license-module:2.8.0
chaosnative/hce-server:2.8.0
chaosnative/hce-subscriber:2.8.0
chaosnative/mongo:4.2.8
chaosnative/argoexec:v3.2.3
chaosnative/chaos-operator:2.8.0
chaosnative/curl:2.8.0
chaosnative/workflow-controller:v3.2.3
chaosnative/k8s:2.8.0
litmuschaos/k8s:latest (Temporary, Will be removed)
chaosnative/litmus-checker:2.8.0
```

Sample HelmChart for HCE installation is available [here]("./hce/")

## Resource Requirements for HCE - 

These resources are getting monitored continuously and the information below will be updated as the metrics changes.

> The metrics given below shows resources consumed when HCE is used at medium scale. The resources may need to be increased when used at higher scale.


**1. Control-plane resource requirements**

<table>
   <tr>
      <th>Pod</th>
      <th>Container</th>
      <th>CPU</th>
      <th>Memory</th>
   </tr>
   <tr>
   <td>hce-frontend</td>
   <td>litmusportal-frontend</td>
   <td>250m</td>
   <td>300M</td>
   </tr>
   <tr>
   <td>hce-auth-server</td>
   <td>auth-server</td>
   <td>250m</td>
   <td>300M</td>
   </tr>
   <tr>
   <td>hce-auth-server</td>
   <td>wait-for-mongodb (init-container)</td>
   <td>125m</td>
   <td>100M</td>
   </tr>
   <tr>
   <td>hce-server</td>
   <td>graphql-server</td>
   <td>125m</td>
   <td>350M</td>
   </tr>
   <tr>
   <td>hce-server</td>
   <td>wait-for-mongodb (init-container)</td>
   <td>125m</td>
   <td>100M</td>
   </tr>
   <tr>
   <td>hce-license-server</td>
   <td>graphql-server</td>
   <td>250m</td>
   <td>300M</td>
   </tr>
   <tr>
   <td>hce-license-server</td>
   <td>wait-for-mongodb (init-container)</td>
   <td>125m</td>
   <td>100M</td>
   </tr>
   <tr>
   <td>mongodb</td>
   <td>mongodb</td>
   <td>250m</td>
   <td>500M</td>
   </tr>
</table>

**2. Execution/Agent plane resource requirements**

<table>
   <tr>
    <th>Pod</th>
    <th>Container</th>
    <th>CPU(Requested)</th>
    <th>Memory(Requested)</th>
   </tr>
   <tr>
    <td>chaos-operator-ce</td>
    <td>chaos-operator-ce</td>
    <td>125m</td>
    <td>300M</td>
   </tr>
   <tr>
    <td>chaos-exporter</td>
    <td>chaos-exporter</td>
    <td>125m</td>
    <td>300M</td>
   </tr>
   <tr>
    <td>event-tracker</td>
    <td>litmus-event-tracker</td>
    <td>125m</td>
    <td>300M</td>
   </tr>
   <tr>
    <td>subscriber</td>
    <td>subscriber</td>
    <td>125m</td>
    <td>300M</td>
   </tr>
   <tr>
    <td>workflow-controller</td>
    <td>workflow-controller</td>
    <td>125m</td>
    <td>300M</td>
   </tr>
</table>