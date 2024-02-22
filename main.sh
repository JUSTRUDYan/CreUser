#!/bin/bash

readonly DEFAULT_RSA_BIT=4096
readonly IP_ADDRESS=$(ip addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -n 1)

parse_options() {
    while getopts ":hn:f:p:b:" opt; do
        case $opt in
            h) help_creuser; exit 0 ;;
            n) user_name="$OPTARG"; ;;
            f) user_path="$OPTARG"; ;;
            p) user_pass_phrase="$OPTARG"; check_pass_phrase "$user_pass_phrase";;
            b) rsa_bit="$OPTARG"; validate_rsa_bit "$rsa_bit";;
            \?) echo "$OPTARG is not an option"; exit 1 ;;
        esac
    done
    shift $OPTIND
}

check_pass_phrase() {
    user_pass_phrase="$1"

    if [ ${#user_pass_phrase} -lt 10 ]; then
        echo "Error: Password phrase is less than 10 characters."
        exit 1
    fi
}

validate_rsa_bit() {
    rsa_bit="$1"

    if [[ ! $rsa_bit =~ ^[0-9]+$ || $rsa_bit -lt 2048 || $rsa_bit -gt 4096 ]]; then
        echo "Error: Invalid RSA key bit length. Must be between 2048 and 4096."
        exit 1
    fi
}

help_creuser() {
    echo "Usage: creuser"
    echo "  -n Name of new user (required)."
    echo "  -f User folder path (required)."
    echo "  -p User pass phrase (required, minimum 10 characters)."
    echo "  -b Bit amount of RSA key (optional, default: $DEFAULT_RSA_BIT)."
    echo "  -h Display this help message."
}

validate_inputs() {
    echo "User creation parameters:"
    echo "  - User Name: $user_name"
    echo "  - User Folder Path: $user_path"
    echo "  - RSA Key Bit Length: $rsa_bit"

    while true; do
        read -p "Are these parameters correct? (yes/no): " answer

        case "$answer" in
            [Yy]*) break ;;
            *) echo "User creation aborted. Please provide correct parameters." && exit 1 ;;
        esac
    done
}

output() {
    echo "Your connection command:"
    echo "ssh -i \"path_to_rsa_key\" $user_name@$IP_ADDRESS"
}

ssh_restart() {
    while true; do
        read -p "Do you need to restart sshd process? (yes/no): " answer

        case "$answer" in
            [Yy]*) sudo systemctl restart sshd && break ;;
            *) echo "sshd restarting canceled." && exit 1 ;;
        esac
    done
}

creuser() {
    parse_options "$@"

    # Use the DEFAULT_RSA_BIT constant if the user didn't specify a bit length
    rsa_bit=${rsa_bit:-$DEFAULT_RSA_BIT}

    if [[ -z "$user_name" || -z "$user_path" || -z "$user_pass_phrase" ]]; then
        echo "Error: Missing required parameters."
        help_creuser
        exit 1
    fi

    if id "$user_name" &>/dev/null; then
        echo "User $user_name exists."
        exit 1
    fi

    validate_inputs

    if [ ! -d "$user_path" ]; then
        mkdir -p "$user_path" || { echo "Failed to create user directory $user_path"; exit 1; }
    fi

    ssh-keygen -t rsa -b "$rsa_bit" -f "$user_path/id_rsa" -N "$user_pass_phrase" || { echo "Failed to generate RSA keys with $rsa_bit bits"; exit 1; }

    useradd -m -d "$user_path" -s /bin/bash "$user_name" || { echo "Failed to create user $user_name"; exit 1; }
    echo "$user_name:$user_pass_phrase" | chpasswd || { echo "Failed to set password for user $user_name"; exit 1; }

    echo "User $user_name created successfully with RSA keys."

    ssh_restart

    output
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    creuser "$@"
fi
