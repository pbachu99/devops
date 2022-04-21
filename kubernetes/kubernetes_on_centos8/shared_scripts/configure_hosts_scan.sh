echo "******************************************************************************"
echo "Amend hosts file with Kubernetes Cluster IPs." `date`
echo "******************************************************************************"
cat >> /etc/hosts <<EOF
# Kubernetes
${CLS_IP_1}    ${FQ_CLUSTER_NAME}	${CLUSTER_NAME}
${CLS_IP_2}    ${FQ_KUBE_NODE1}		${KUBE_NODE1}
${CLS_IP_3}    ${FQ_KUBE_NODE2}		${KUBE_NODE2}
EOF

