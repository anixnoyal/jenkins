#!/bin/bash

# Configuration
SERVICE_NAME="shutdown-script"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"
SCRIPT_PATH="/usr/local/bin/${SERVICE_NAME}-script.sh"

# Create the script to be executed during shutdown/restart
echo "Creating the shutdown script at ${SCRIPT_PATH}..."
sudo tee "${SCRIPT_PATH}" > /dev/null << 'EOF'
#!/bin/bash
# Custom script to run at shutdown or restart
echo "Running custom shutdown script at $(date)" >> /var/log/shutdown-script.log
EOF

# Make the script executable
sudo chmod +x "${SCRIPT_PATH}"

# Create the systemd service unit file
echo "Creating the systemd service file at ${SERVICE_FILE}..."
sudo tee "${SERVICE_FILE}" > /dev/null << EOF
[Unit]
Description=Run custom script at shutdown or reboot
DefaultDependencies=no
Before=shutdown.target reboot.target halt.target poweroff.target

[Service]
Type=oneshot
ExecStart=${SCRIPT_PATH}
RemainAfterExit=yes

[Install]
WantedBy=halt.target poweroff.target reboot.target
EOF

# Reload systemd to recognize the new service
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

# Enable the service to run at shutdown or restart
echo "Enabling the ${SERVICE_NAME} service..."
sudo systemctl enable "${SERVICE_NAME}.service"

# Verify the service status
echo "Verifying the ${SERVICE_NAME} service status..."
sudo systemctl status "${SERVICE_NAME}.service"

echo "Setup complete."
