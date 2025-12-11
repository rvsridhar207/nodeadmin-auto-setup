#!/bin/bash
set -e

sudo useradd -m -s /bin/bash nodeadmin
sudo usermod -aG sudo nodeadmin

sudo mkdir -p /home/nodeadmin/.ssh
sudo touch /home/nodeadmin/.ssh/authorized_keys
sudo chmod 700 /home/nodeadmin/.ssh
sudo chmod 600 /home/nodeadmin/.ssh/authorized_keys
sudo chown -R nodeadmin:nodeadmin /home/nodeadmin/.ssh

echo "Set a local password for nodeadmin (used only for sudo):"
sudo passwd nodeadmin

echo "Paste public SSH key for nodeadmin, press Enter, and then press Ctrl+D:"
sudo tee /home/nodeadmin/.ssh/authorized_keys >/dev/null
sudo chown nodeadmin:nodeadmin /home/nodeadmin/.ssh/authorized_keys

# Disable root login & password authentication
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config 2>/dev/null
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config 2>/dev/null

sudo find /etc/ssh/sshd_config.d/ -type f -name '*.conf' \
  -exec sudo sed -i \
  's/^#\?PermitRootLogin.*/PermitRootLogin no/; s/^#\?PasswordAuthentication.*/PasswordAuthentication no/' {} + 2>/dev/null

sudo passwd -l root >/dev/null 2>&1

sudo systemctl restart ssh

echo "✅ nodeadmin created with SSH key login only and sudo password enabled."