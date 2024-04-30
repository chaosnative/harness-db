# Running Node Drain Chaos Experiment on an Autopilot Cluster having Composer deployed

- Run below command to read & save all PDB minAvailable Values in a file as backup -
```bash
kubectl get pdb -A -o json | jq -r '.items[] | select(.spec.minAvailable >= 1)  | [.metadata.name , .metadata.namespace, .spec.minAvailable] | @tsv' >> pdb_namespace_originalMinimalAvailable_list.txt
```

- Run below command to patch PDBs to have value of minAvailable so that we can run Chaos/Node Drain
```bash
while read p; do \
PDB=$(echo $p | awk '{print $1}') ; \
echo PDB: ${PDB} ; \
NS=$(echo $p | awk '{print $2}') ; \
echo NS: ${NS} ; \
kubectl patch pdb $PDB -n $NS --type=merge -p '{"spec":{"minAvailable":0}}' ; \
done <  pdb_namespace_originalMinimalAvailable_list.txt
```

- Now you can run Node Drain experiments on an Autopilot cluster where composer/airflow is deployed.

- Once experiment is finished, Run below command to revert the PDB values to get to initial state -
```bash
while read p; do \
PDB=$(echo $p | awk '{print $1}') ; \
echo PDB: ${PDB} ; \
NS=$(echo $p | awk '{print $2}') ; \
echo NS: ${NS} ; \
Original_Min_Available=$(echo $p | awk '{print $3}') ; \
echo  Original_Min_Available: ${Original_Min_Available} ; \
command=`echo "kubectl patch pdb ${PDB} -n ${NS} --type=merge -p 
'{\"spec\":{\"minAvailable\":${Original_Min_Available}}}'"` ;\
echo ${command} ;\
eval ${command} ;\
done < pdb_namespace_originalMinimalAvailable_list.txt
```