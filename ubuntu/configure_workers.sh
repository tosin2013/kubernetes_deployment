#!/bin/bash
set -xe
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

# Configuration
USERNAME="$1"
SSH_KEY_PATH="${HOME}/.ssh/cluster-key"
DOCKER_SCRIPT="./ubuntu/configure_docker.sh"
KUBEADM_SCRIPT="./ubuntu/kubeadmin.sh"
FIREWALL_PORTS_SCRIPT="./ubuntu/configure_firewall_ports.sh"
ADD_WORKER_SCRIPT="/tmp/addworker.sh"

# Check if the username argument is provided
if [[ $# -ne 1 ]]; then
    echo "USAGE: $0 username"
    echo "USAGE EXAMPLE: $0 admin"
    exit 1
fi

# Check if the SSH key exists and set SSH_KEY_PATH
if [[ -f "${SSH_KEY_PATH}" ]]; then
    eval "$(ssh-agent -s)"
    ssh-add "${SSH_KEY_PATH}"
else
    echo "SSH key not found at ${SSH_KEY_PATH}"
    exit 1
fi

# Function to validate an IP address using a regular expression
function valid_ip() {
    local ip="$1"

    if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        IFS='.'
        ip=($ip)
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        return $?
    fi

    return 1
}

# Function to check if a node is already in kubectl get nodes and labeled as a worker
function node_exists_and_labeled() {
    local node_name="$1"
    
    # Check if the node is an IP address
    if valid_ip "${node_name}"; then
        # Get the hostname associated with the IP address from /etc/hosts
        local hostname=$(grep -E "^\s*${node_name}\s+" /etc/hosts | awk '{print $2}' | head -n 1 | tr -d '\r')
        if [ -n "${hostname}" ]; then
            node_name="${hostname}"
        fi
    fi

    # Check if the node exists and is labeled as a worker
    kubectl get nodes "${node_name}" | grep 'worker' > /dev/null
    return $?
}

# Function to test and update worker nodes
function test_workernode() {
    local IP="$1"
    local MACHINENAME

    MACHINENAME=$(ssh -o PasswordAuthentication=no -o ConnectTimeout=10 -i "${SSH_KEY_PATH}" -t "${USERNAME}@${IP}" hostname 2>&1)
    
    echo "HOSTNAME: ${MACHINENAME}"

    # Check if the machine is already in /etc/hosts
    if grep -qF "${IP}    ${MACHINENAME}" /etc/hosts; then
        echo "Machine $IP is already in /etc/hosts."
    else
        # Ping the machine by hostname
        if ping -q -c 5 "${MACHINENAME}" > /dev/null; then
            echo "Worker node $IP is reachable."
        else
            # Add the machine to /etc/hosts
            sudo -- sh -c "echo '${IP}    ${MACHINENAME}' >> /etc/hosts"
            sudo cat /etc/hosts
        fi
    fi
}


# 1. Read the file and extract the "kubeadm join" command with token, excluding trailing backslash
command=$(cat /tmp/kubeadminit.log | grep -i "kubeadm join.*--token.*" -o | sed 's/\\$//')

# 2. Add the "--discovery-token-unsafe-skip-ca-verification" flag
new_command="${command} --discovery-token-unsafe-skip-ca-verification"

# 3. Echo the modified command (uncomment to execute it directly)
echo "${new_command}"
echo -e "#!/bin/bash\nsudo $command" > "${ADD_WORKER_SCRIPT}"

# Find the workers file and read the IP addresses
WORKERSFILE=$(find ~ -name workers)
CHECKIPS=$(cat "${WORKERSFILE}")

for worker in ${CHECKIPS}; do
    if valid_ip "${worker}"; then
        echo "Worker: ${worker}"

        # Check if the node already exists and is labeled as a worker
        if node_exists_and_labeled "${worker}"; then
            echo "Node $worker already exists in kubectl and is labeled as a worker. Skipping..."
        else
            test_workernode "${worker}"

            # Copy necessary scripts to the worker node
            scp -i "${SSH_KEY_PATH}" "${DOCKER_SCRIPT}" "${USERNAME}@${worker}:/tmp/configure_docker.sh"
            scp -i "${SSH_KEY_PATH}" "${KUBEADM_SCRIPT}" "${USERNAME}@${worker}:/tmp/kubeadmin.sh"
            ssh -o PasswordAuthentication=no -o ConnectTimeout=10 -i "${SSH_KEY_PATH}" "${USERNAME}@${worker}" "sh /tmp/configure_docker.sh" || exit $?
            ssh -o PasswordAuthentication=no -o ConnectTimeout=10 -i "${SSH_KEY_PATH}" "${USERNAME}@${worker}" "sh /tmp/kubeadmin.sh"

            scp -i "${SSH_KEY_PATH}" "${FIREWALL_PORTS_SCRIPT}" "${USERNAME}@${worker}:/tmp/configure_firewall_ports.sh"
            ssh -o PasswordAuthentication=no -o ConnectTimeout=10 -i "${SSH_KEY_PATH}" "${USERNAME}@${worker}" "/tmp/configure_firewall_ports.sh worker" || exit $?

            scp -i "${SSH_KEY_PATH}" "${ADD_WORKER_SCRIPT}" "${USERNAME}@${worker}:${ADD_WORKER_SCRIPT}"
            ssh -o PasswordAuthentication=no -o ConnectTimeout=10 -i "${SSH_KEY_PATH}" "${USERNAME}@${worker}" "sh ${ADD_WORKER_SCRIPT}" || exit $?

            # Label the worker node
            MACHINENAME=$(ssh -o PasswordAuthentication=no -o ConnectTimeout=10 -i "${SSH_KEY_PATH}" "${USERNAME}@${worker}" hostname 2>&1)
            NEWNAME=$(echo "${MACHINENAME}" | awk '{print $1}' | tr -d '\r' | sed -e 's/^"//' -e 's/"$//')
            kubectl label node "${NEWNAME}" node-role.kubernetes.io/worker=worker || exit $?

            sleep 3s
            kubectl get nodes
        fi
    fi
done
