#!/bin/bash

# --- Configuration ---
USER="mario"
SERVICE_DIR="$HOME/.config/systemd/user"
SCRIPT_PATH="/home/$USER/bashscripts/filemove.sh"

# Ensure the systemd user directory exists
mkdir -p "$SERVICE_DIR"

# 1. Create the Service File
cat <<EOF > "$SERVICE_DIR/filemove.service"
# Location: /home/$USER/.config/systemd/user/filemove.service
[Unit]
Description=Organize Downloads Folder
After=local-fs.target

[Service]
Type=oneshot
ExecStart=/bin/bash $SCRIPT_PATH

[Install]
WantedBy=default.target
EOF

echo "Created filemove.service in $SERVICE_DIR"

# 2. Create the Timer File
cat <<EOF > "$SERVICE_DIR/filemove.timer"
# Location: /home/$USER/.config/systemd/user/filemove.timer
[Unit]
Description=Run Download Organizer every 5 minutes

[Timer]
# Run 5 minutes after the service last finished
OnUnitActiveSec=5min
# Run 1 minute after boot
OnBootSec=1min

[Install]
WantedBy=timers.target
EOF

echo "Created filemove.timer in $SERVICE_DIR"

# 3. Activation
echo "Reloading systemd user daemon and enabling timer..."
systemctl --user daemon-reload
systemctl --user enable --now filemove.timer

echo "Setup complete. Use 'systemctl --user list-timers' to verify."
