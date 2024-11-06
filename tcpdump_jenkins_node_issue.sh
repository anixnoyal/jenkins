tcpdump -i eth0 '(dst host 192.168.1.10 and (port 443 or port 8443 or port 8001)) or (dst host 192.168.1.20 and (port 443 or port 8443 or port 8001))' -w jenkins_connection.pcap
