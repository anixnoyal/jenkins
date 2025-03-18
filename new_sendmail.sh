sed -i -E '/confMAX_DAEMON_CHILDREN/ s/^dnl *//' /etc/mail/sendmail.mc || echo "define(\`confMAX_DAEMON_CHILDREN\', \`100\')dnl" | sudo tee -a /etc/mail/sendmail.mc
sed -i -E '/confCONNECTION_RATE_THROTTLE/ s/^dnl *//' /etc/mail/sendmail.mc || echo "define(\`confCONNECTION_RATE_THROTTLE\', \`0\')dnl" | sudo tee -a /etc/mail/sendmail.mc

make -C /etc/mail
systemctl restart sendmail
systemctl status sendmail
