#!/bin/bash
sudo yum check-update
sudo yum -y update
sudo yum -y install httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl status httpd | grep Active
sudo cat > /var/www/html/index.html << EOF
<html>
<head>
  <title> DevOps </title>
</head>
<body>
  <p> DevOps Onboarding task
</body>
</html>
EOF