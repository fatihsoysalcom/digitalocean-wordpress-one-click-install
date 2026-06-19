#!/bin/bash

# This script demonstrates how to provision a DigitalOcean Droplet with a one-click WordPress installation.
# It assumes you have the DigitalOcean CLI (doctl) installed and authenticated.
# Replace 'your-ssh-key-fingerprint' with your actual SSH key fingerprint.

# --- Configuration ---
DROPLET_NAME="wordpress-droplet-$(date +%s)"
REGION="nyc3" # Choose your preferred region
SIZE="s-1vcpu-1gb" # Choose your preferred Droplet size
IMAGE="wordpress-20-04-x64" # DigitalOcean's one-click WordPress image
SSH_KEY_FINGERPRINT="your-ssh-key-fingerprint" # IMPORTANT: Replace with your SSH key fingerprint

# --- Script Logic ---

echo "Creating DigitalOcean Droplet with WordPress one-click install..."

# Use doctl to create the Droplet with the specified image and SSH key
droplet_create_output=$(doctl compute droplet create \
  --name "$DROPLET_NAME" \
  --region "$REGION" \
  --size "$SIZE" \
  --image "$IMAGE" \
  --ssh-keys "$SSH_KEY_FINGERPRINT" \
  --wait)

# Extract the Droplet ID from the output
DROPLET_ID=$(echo "$droplet_create_output" | grep -oP 'ID:\s*\K\d+')

if [ -z "$DROPLET_ID" ]; then
  echo "Error: Failed to create Droplet or extract Droplet ID."
  exit 1
fi

echo "Droplet '$DROPLET_NAME' created successfully with ID: $DROPLET_ID"

# Fetch the Droplet's IP address
DROPLET_IP=$(doctl compute droplet get "$DROPLET_ID" --format PublicIPv4 --no-header)

if [ -z "$DROPLET_IP" ]; then
  echo "Error: Failed to retrieve Droplet IP address."
  exit 1
fi

echo "WordPress Droplet is ready at: http://$DROPLET_IP"
echo "You can now access your WordPress installation via your web browser."
echo "DigitalOcean's one-click image handles the initial WordPress setup."

exit 0
