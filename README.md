### **Bash Script for User Creation with RSA Keys**

This Bash script provides a command-line interface for creating a new user with RSA keys. It allows users to specify various parameters such as the user name, user folder path, user pass phrase, and RSA key bit length.

### **Usage**

```bash
./creuser.sh -n <user_name> -f <user_folder_path> -p <user_pass_phrase> -b <rsa_key_bit_length>
```

### **Options**

- **`n`**: Name of the new user (required).
- **`f`**: User folder path (required).
- **`p`**: User pass phrase (required, minimum 10 characters).
- **`b`**: Bit amount of RSA key (optional, default: 4096).
- **`h`**: Display help message.

### **Usage Example**

```bash
./creuser.sh -n pupyan -f /home/pupyan -p password1234
```

Note: The script will prompt for confirmation before proceeding with user creation.

### **Script Description**

The script follows a clean and structured code style. It includes functions for parsing options, checking password phrases, validating RSA key bit lengths, and displaying help messages. Additionally, it prompts users for confirmation and provides information about the user creation process.

### **Output**

Upon successful user creation, the script outputs a connection command for SSH with the newly created user and IP address.

```bash
Your connection command:
ssh -i "path_to_rsa_key" pupyan@<IP_ADDRESS>
```

### **SSH Daemon Restart**

The script also offers an option to restart the SSH daemon after user creation, providing additional flexibility.

### **Running the Script**

To execute the script, use the following command:

```bash
./creuser.sh -n <user_name> -f <user_folder_path> -p <user_pass_phrase> -b <rsa_key_bit_length>
```

Ensure that the script has the necessary permissions for execution:

```bash
chmod +x creuser.sh
```

If executed directly, the script will create the specified user and RSA keys.
