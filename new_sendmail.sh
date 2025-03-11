define(`confMAX_DAEMON_CHILDREN', `100')dnl
define(`confCONNECTION_RATE_THROTTLE', `0')dnl
define(`confQUEUE_LA', `12')dnl
define(`confREFUSE_LA', `18')dnl
define(`confTO_QUEUERETURN', `4h')dnl
define(`confTO_QUEUEWARN', `1h')dnl

make -C /etc/mail
systemctl restart sendmail
systemctl status sendmail
