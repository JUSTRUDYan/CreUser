### **Bash Script for User Creation with RSA Keys**

This Bash script provides a command-line interface for creating a new user with RSA keys. It allows users to specify various parameters such as the user name, user folder path, user pass phrase, and RSA key bit length.

### Usage

```bash
bashCopy code
./creuser.sh -n <user_name> -f <user_folder_path> -p <user_pass_phrase> -b <rsa_key_bit_length>

```

### Options

- **`n`**: Name of the new user (required).
- **`f`**: User folder path (required).
- **`p`**: User pass phrase (required, minimum 10 characters).
- **`b`**: Bit amount of RSA key (optional, default: 4096).
- **`h`**: Display help message.

### Usage Example

```bash
bashCopy code
./creuser.sh -n pupyan -f /home/pupyan -p password1234

```

Note: The script will prompt for confirmation before proceeding with user creation.