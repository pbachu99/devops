echo "******************************************************************************"
echo "Amend hosts file with Nodes and IPs." `date`
echo "******************************************************************************"
cat >> /etc/hosts <<EOF
# Public
${NODE1_PUBLIC_IP}  ${NODE1_FQ_HOSTNAME}  ${NODE1_HOSTNAME}
${NODE2_PUBLIC_IP}  ${NODE2_FQ_HOSTNAME}  ${NODE2_HOSTNAME}
${NODE3_PUBLIC_IP}  ${NODE3_FQ_HOSTNAME}  ${NODE3_HOSTNAME}
EOF
