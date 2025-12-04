#!/bin/bash
# run as root
set -e

# Update & install nginx
yum update -y
amazon-linux-extras install -y nginx1
yum install -y nginx

# Create non-root deploy user
useradd -m deploy || true
mkdir -p /home/deploy/.ssh
chown -R deploy:deploy /home/deploy/.ssh

# Simple resume HTML (replace with your real resume)
cat > /usr/share/nginx/html/index.html <<'EOF'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Raghav Pratap — Resume</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <style>
    body{font-family: Arial, Helvetica, sans-serif; max-width:760px;margin:32px auto;color:#111}
    header{border-bottom:1px solid #ddd;padding-bottom:8px;margin-bottom:12px}
    h1{margin:0}
    .section{margin:18px 0}
  </style>
</head>
<body>
  <header>
    <h1>Raghav Pratap</h1>
    <p>Computer Science Student — Resume (Static site)</p>
  </header>
  <div class="section">
    <h2>Education</h2>
    <p>B.Tech Computer Science — DIT University</p>
  </div>
  <div class="section">
    <h2>Skills</h2>
    <ul><li>Python, C, Git, Linux, Terraform</li></ul>
  </div>
  <div class="section">
    <h2>Contact</h2>
    <p>Email: raghavpratapsoni@gmail.com</p>
  </div>
</body>
</html>
EOF

# Ensure permissions
chown root:root /usr/share/nginx/html/index.html
chmod 644 /usr/share/nginx/html/index.html

# Enable & start nginx
systemctl enable nginx
systemctl start nginx

# Basic firewall (optional — Security Group is primary)
# If you want a host firewall, configure here (e.g. install and configure iptables/ufw)
# For Amazon Linux 2 we typically rely on Security Groups for inbound control.

# (Optional) Enable automatic security updates
yum install -y yum-cron
systemctl enable --now yum-cron

# Write a note for provisioner/debug
echo "Provision complete at $(date)" > /var/log/provision-complete.txt
