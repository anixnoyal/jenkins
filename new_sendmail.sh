sed -i '/confMAX_DAEMON_CHILDREN/d' /etc/mail/sendmail.mc
sed -i '/confCONNECTION_RATE_THROTTLE/d' /etc/mail/sendmail.mc

sudo tee -a /etc/mail/sendmail.mc > /dev/null << 'EOF'
define(`confMAX_DAEMON_CHILDREN', `100')dnl
define(`confCONNECTION_RATE_THROTTLE', `0')dnl
EOF

make -C /etc/mail
systemctl restart sendmail
systemctl status sendmail
