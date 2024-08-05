#!/bin/bash
echo "Installing x86 prereqs"
dpkg --add-architecture i386
apt-get update
apt-get -y install libc6:i386 libncurses5:i386 libstdc++6:i386

echo "Creating dedcon user"
adduser --system dedcon

echo "Downloading Dedcon"
wget -O dedcon-i686-pc-linux-gnu-1.6.0.tar.bz2 https://dedcon.simamo.de/bin/dedcon-i686-pc-linux-gnu-1.6.0.tar.bz2

echo "Extracting Dedcon"
tar -xjf dedcon-i686-pc-linux-gnu-1.6.0.tar.bz2 -C /usr/local/bin

cd /usr/local/bin/dedcon-i686-pc-linux-gnu-1.6.0
cp ConfigFile.sample ConfigFile
chown -R dedcon:root /usr/local/bin/dedcon-i686-pc-linux-gnu-1.6.0/

# create service file
echo "Creating service file"
cat > /etc/systemd/system/dedcon.service << EOF
[Unit]
Description="Dedcon game server service"
After=network.target
[Service]
User=dedcon
WorkingDirectory=/usr/local/bin/dedcon-i686-pc-linux-gnu-1.6.0
ExecStart=/usr/local/bin/dedcon-i686-pc-linux-gnu-1.6.0/loop.sh ConfigFile
Restart=no
[Install]
WantedBy=multi-user.target
EOF

echo "Reloading daemon"
sudo systemctl daemon-reload

echo "Enabling dedcon service"
sudo systemctl enable dedcon

echo "Starting dedcon service"
sudo systemctl start dedcon

echo "Service Started"
