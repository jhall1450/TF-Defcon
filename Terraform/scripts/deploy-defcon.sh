#!/bin/bash
echo "Downloading Dedcon"

wget -O dedcon-i686-pc-linux-gnu-1.6.0.tar.bz2 https://dedcon.simamo.de/bin/dedcon-i686-pc-linux-gnu-1.6.0.tar.bz2

echo "Extracting Dedcon"
tar -xf dedcon-i686-pc-linux-gnu-1.6.0.tar.bz2 -C /usr/local/bin

cd /usr/local/bin/dedcon-i686-pc-linux-gnu-1.6.0

chmod +x loop.sh dedcon

echo "Starting Dedcon Server on port 5010"
./loop.sh