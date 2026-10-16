#!/bin/bash

ALERT_EMAIL="adrianavarela074@gmail.com"
SENDER_EMAIL="fail2ban@$(hostname -f)"

echo "A instalar o serviço de Fail2ban..."

sudo dnf install epel-release -y
sudo dnf install fail2ban sendmail -y

echo ""
echo ""

echo "A estruturar as regras e jails..."
echo ""

sudo cat <<EOF > /etc/fail2ban/jail.local
[DEFAULT]
ignoreip = 127.0.0.1/8 ::1
bantime = 3600
findtime = 600
maxretry = 3
backend = systemd

destemail = ${ALERT_EMAIL}
sender = ${SENDER_EMAIL}
mta = sendmail

action = %(action_mwl)s

[sshd]
enabled = true
port = ssh
logpath = /var/log/secure

[apache-auth]
enabled= true
port = http,https
logpath = /var/log/httpd/error_log

[apache-badbots]
enabled = true
port = http,https
logpath = /var/log/httpd/access_log

[apache-noscript]
enable = true
port = http,https
logpath = /var/log/http/error_log

EOF

echo "A iniciar o fail2ban..."
echo ""
sudo systemctl daemon-reload
sudo systemctl enable --now sendmail
sudo systemctl enable --now fail2ban

sudo touch /var/log/httpd/access_log /var/log/httpd/error_log
sudo systemctl restart fail2ban


echo ""
echo "Fail2ban configurado com sucesso!"
echo ""

