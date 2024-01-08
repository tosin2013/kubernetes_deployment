#!/bin/bash


# Function to install sshpass on Ubuntu
install_sshpass_ubuntu() {
    sudo apt-get update
    sudo apt-get install -y sshpass
}

# Function to install sshpass on Fedora
install_sshpass_fedora() {
    sudo dnf install -y sshpass
}

# Check if sshpass is installed and install it if necessary
if ! command -v sshpass &>/dev/null; then
    echo "sshpass is not installed. Installing..."
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        case $ID in
            ubuntu)
                install_sshpass_ubuntu
                ;;
            fedora)
                install_sshpass_fedora
                ;;
            *)
                echo "Unsupported Linux distribution. Please install sshpass manually."
                exit 1
                ;;
        esac
    else
        echo "Unsupported Linux distribution. Please install sshpass manually."
        exit 1
    fi
fi


if [[ $# -ne 2 ]]; then
    echo "Usage:"
    echo "  ./setup-passwordless.sh username_name password"
    echo "Example:"
    echo "  ./setup-passwordless.sh admin password123"
    exit 1
fi

# Check for existing SSH key
CHECKSSHKEYPATH=$(ls -al ~/.ssh/cluster-key.pub 2>/dev/null)
if [[ -z $CHECKSSHKEYPATH ]]; then
    echo "Generating a new SSH key pair."
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/cluster-key -N ''
    ls ~/.ssh/cluster-key || exit $?
fi


# Check if the workers file exists
if [[ ! -f "workers" ]]; then
    echo "Error: 'workers' file not found. Create the file with one machine name per line."
    exit 1
fi

# Read machine names from the workers file
for MACHINE in $(grep -vE '^\s*#' "workers"); do
    USERNAME="${1}"
    PASSWORD="${2}"

    # Check for existing SSH key
    CHECKSSHKEYPATH=$(ls -al ~/.ssh/cluster-key.pub 2>/dev/null)
    if [[ -z $CHECKSSHKEYPATH ]]; then
        echo "Generating a new SSH key pair."
        ssh-keygen -t rsa -b 4096 -f ~/.ssh/cluster-key -N ''
        ls ~/.ssh/cluster-key || exit $?
    fi

    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/cluster-key

    # Use sshpass to automate password entry
    if ssh -o PasswordAuthentication=no -o ConnectTimeout=10 "${USERNAME}@${MACHINE}" ls -lath 2>/dev/null; then
        echo "Skipping SSH configuration for ${MACHINE}."
    else
        sshpass -p "${PASSWORD}" ssh-copy-id "${USERNAME}@${MACHINE}"
        cat ~/.ssh/cluster-key.pub | sshpass -p "${PASSWORD}" ssh "${USERNAME}@${MACHINE}" "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
        ssh -o PasswordAuthentication=no -o ConnectTimeout=10 "${USERNAME}@${MACHINE}" ls -lath || exit $?
    fi
done
