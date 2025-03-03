#!/bin/bash

LOG_FILE="/var/log/maillog"   # Change this if your sendmail log is different
ERROR_LOG="/tmp/sendmail_errors.log"

echo "Checking sendmail errors... (Output saved in $ERROR_LOG)"
echo "================ Sendmail Error Report =================" > "$ERROR_LOG"
echo "Timestamp: $(date)" >> "$ERROR_LOG"
echo "" >> "$ERROR_LOG"

# Check if sendmail is running
if ! pgrep -x sendmail > /dev/null; then
    echo "ERROR: Sendmail is not running!" | tee -a "$ERROR_LOG"
    echo "Trying to restart sendmail..." | tee -a "$ERROR_LOG"
    systemctl restart sendmail
    exit 1
fi

# Check for segmentation faults
echo "Checking for segmentation faults..." >> "$ERROR_LOG"
grep -i "segmentation fault" "$LOG_FILE" | tail -5 >> "$ERROR_LOG"
dmesg | grep -i sendmail | grep -i "segfault" | tail -5 >> "$ERROR_LOG"

# Check for connection refused errors
echo "Checking for connection refused errors..." >> "$ERROR_LOG"
grep -i "connection refused" "$LOG_FILE" | tail -5 >> "$ERROR_LOG"
netstat -tulnp | grep :25 >> "$ERROR_LOG"

# Check for out-of-memory errors
echo "Checking for Out of Memory errors..." >> "$ERROR_LOG"
grep -i "Out of memory" /var/log/messages | tail -5 >> "$ERROR_LOG"
dmesg | grep -i "oom" | tail -5 >> "$ERROR_LOG"
free -m >> "$ERROR_LOG"

# Check for queue file errors
echo "Checking mail queue issues..." >> "$ERROR_LOG"
ls -ld /var/spool/mqueue >> "$ERROR_LOG"
mailq >> "$ERROR_LOG"

# Print summary
echo "========= Summary =========" | tee -a "$ERROR_LOG"
if grep -qi "segmentation fault" "$ERROR_LOG"; then echo "❌ Segmentation fault detected!"; fi
if grep -qi "connection refused" "$ERROR_LOG"; then echo "❌ Connection refused detected!"; fi
if grep -qi "out of memory" "$ERROR_LOG"; then echo "❌ Out of memory issue detected!"; fi
if grep -qi "mqueue" "$ERROR_LOG"; then echo "❌ Mail queue errors detected!"; fi

echo "✅ Check completed. View full report: $ERROR_LOG"
