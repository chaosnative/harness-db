# Running Chaos-Experiments on an Autopilot Clusters

Due to many restrictions provided below via GCP Autopilot clusters, we cannot run most of the chaos faults.

## What are the Restrictions?
- Linux Capabilities (NET_ADMIN, SYS_ADMIN) can’t be used
- `hostPID: true` can’t be used
- Privileged containers can’t be used
- HostPath volume (socketPath) mounting in `write mode` not allowed
- SSH to nodes is not allowed

## Which faults/Categories can’t be executed?

- API-Chaos
- HTTP-Chaos
- IO-Chaos
- Network-Chaos
- Node-Network-Chaos
- DNS Chaos
- Stress-Chaos
- Kubectl-SVC-Kill
- Node Taint
- Node Restart
- Container-Kill
- Disk Fill

## Transient issues which can happen while running a Chaos Experiment

- Nodes can scale up/down anytime based on resource usage, our runner/experiment/probe pods can rescheduled - Results can be flaky
- Even if it doesn't affect the experiment/runner pods, if probe pods take time to come into Running state, experiment can fail.
- The duration of the experiment could be anything based on how Autopilot scales up/down & how the experiment progresses.

## Alternate Experiments which can run on Autopilot clusters - 

- Pod Network Partition
- Node Drain
- Pod Memory Hog Exec
- Pod CPU Hog Exec
- Locust-Loadgen
- Pod-Auto-Scaler
- Pod-Delete

## Notes

To reduce the flakiness, Healthcheck will have to be inline probes.







