#!/bin/bash
sudo tee -a /etc/ssh/sshd_config > /dev/null <<EOT
ClientAliveInterval 600
TCPKeepAlive yes
ClientAliveCountMax 10
EOT

sudo /etc/init.d/ssh restart
