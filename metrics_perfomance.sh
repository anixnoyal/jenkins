#ostat: To monitor IOPS, use:
iostat -dx 2

#sar: To get detailed disk activity, use:
sar -d 2 5




Step 1: Install the Metrics Plugin
Step 2: Configure the Metrics Plugin

Go to Manage Jenkins -> Configure System.
Scroll down to find the Metrics section.
You need to add an access key for authentication:
Click Add next to the Metrics Access Key.
Choose a username or purpose for the key (this is just a label).
Click Generate. It will create an access key that you can use to authenticate API requests.

/metrics/5_X226xqLSyX2_0_7nh6XQ0T1dsJUthG9unKPQxNOqISXwJcT8CxzXmWoB6HJaCc/metrics

5_X226xqLSyX2_0_7nh6XQ0T1dsJUthG9unKPQxNOqISXwJcT8CxzXmWoB6HJaCc


http://your-jenkins-url/metrics/{key}/metrics

Health checks: 
  http://your-jenkins-url/metrics/{key}/healthcheck
Ping: 
  http://your-jenkins-url/metrics/{key}/ping
