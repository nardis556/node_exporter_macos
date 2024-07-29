#!/bin/bash

curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest \
| grep "browser_download_url.*darwin-amd64.tar.gz" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi -

tar xvfz node_exporter-*.darwin-amd64.tar.gz && mv node_exporter-*darwin-amd64 node_exporter

cat <<EOF | sudo tee /Library/LaunchDaemons/node_exporter.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>node_exporter</string>
    <key>ProgramArguments</key>
    <array>
        <string>$PWD/node_exporter/node_exporter</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

# Load the launchd job
sudo launchctl load /Library/LaunchDaemons/node_exporter.plist
