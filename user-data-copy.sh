#!/bin/bash
# Variables
KEYVAULT_NAME="dev-vmsskeyvault1"
SECRET_NAME="azuregitpass"
REPO_URL="dev.azure.com/AmarS0707/nodejs-project-cicd/_git/tf"
BRANCH="dev"  # Replace with your branch if different
TARGET_DIR="/var/www/html/web"
mkdir -p $TARGET_DIR
# Install necessary packages
apt-get update
apt-get install -y jq curl git net-tools
# Function to get OAuth2 token using Managed Identity
get_access_token() {
    TOKEN_URL="http://169.254.169.254/metadata/identity/oauth2/token"
    TOKEN_RESPONSE=$(curl -s -H "Metadata: true" "$TOKEN_URL?api-version=2018-02-01&resource=https://vault.azure.net")
    ACCESS_TOKEN=$(echo $TOKEN_RESPONSE | jq -r '.access_token')
    echo $ACCESS_TOKEN
}

# Fetch the access token
ACCESS_TOKEN=$(get_access_token)

# Check if the token was retrieved successfully
if [ -z "$ACCESS_TOKEN" ]; then
    echo "Failed to obtain access token."
    exit 1
fi

# Fetch the secret from Azure Key Vault
SECRET_RESPONSE=$(curl -s -H "Authorization: Bearer $ACCESS_TOKEN" "https://$KEYVAULT_NAME.vault.azure.net/secrets/$SECRET_NAME?api-version=7.3")

# Check if the secret was retrieved successfully
if [ $? -ne 0 ]; then
    echo "Failed to fetch the secret from Azure Key Vault."
    exit 1
fi

# Extract the secret value
SECRET_VALUE=$(echo $SECRET_RESPONSE | jq -r '.value')

# Check if the secret value is empty
if [ -z "$SECRET_VALUE" ]; then
    echo "The secret value is empty."
    exit 1
fi

# Construct the Git URL with the secret (assuming HTTPS authentication)
GIT_URL="https://amars:${SECRET_VALUE}@${REPO_URL}"

# Perform git clone
git clone -b $BRANCH $GIT_URL $TARGET_DIR

# Check if git clone was successful
if [ $? -ne 0 ]; then
    echo "Failed to clone the repository."
    exit 1
fi

echo "Repository cloned successfully."

# Any other setup or application logic can be added here

# Example: Install NGINX and serve the content
echo "Installing NGINX..."
apt-get install -y nginx

# echo "Configuring NGINX..."
# cat > /etc/nginx/sites-available/default <<EOF
# server {
#     listen 80;
#     server_name localhost;

#     root $TARGET_DIR;
#     index index.html;

#     location / {
#         try_files \$uri \$uri/ =404;
#     }
# }
# EOF

# echo "Restarting NGINX..."
# systemctl restart nginx

echo "Setup complete. NGINX is serving content from the Git repository."
