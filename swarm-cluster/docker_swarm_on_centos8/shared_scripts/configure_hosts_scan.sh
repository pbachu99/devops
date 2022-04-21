echo "******************************************************************************"
echo "Amend hosts file with SWARM Cluster IPs." `date`
echo "******************************************************************************"
cat >> /etc/hosts <<EOF
# SWARM Cluster Ips
${CLS_IP_1}    ${FQ_CLUSTER_NAME}	${CLUSTER_NAME}
${CLS_IP_2}    ${FQ_SWARM_NODE1}		${SWARM_NODE1}
${CLS_IP_3}    ${FQ_SWARM_NODE2}		${SWARM_NODE2}
EOF

