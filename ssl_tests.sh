#!/bin/bash

# Set your domain name here
DOMAIN="yourdomain.com"

# SSL Labs Test (requires manual intervention to view results in the browser)
echo "Starting SSL Labs Test for $DOMAIN..."
echo "Visit https://www.ssllabs.com/ssltest/analyze.html?d=$DOMAIN to view the detailed SSL Labs report."

# Browser Test - This would require manual steps to verify in a real browser

# Test Certificate Details with OpenSSL
echo "Testing Certificate Details with OpenSSL..."
openssl s_client -connect $DOMAIN:443 -servername $DOMAIN | openssl x509 -noout -text | grep -E 'Issuer:|Not After|Public Key Algorithm'

# Check Certificate Chain
echo "Checking Certificate Chain with OpenSSL..."
openssl s_client -connect $DOMAIN:443 -servername $DOMAIN -showcerts | openssl x509 -noout -text | grep -E 'Certificate:|Issuer:|Subject:'

# Verify HTTPS Connection with cURL
echo "Verifying HTTPS Connection with cURL..."
curl -Iv https://$DOMAIN 2>&1 | grep -E 'SSL certificate|expire date'

# Test on Multiple Browsers/Devices - This would require manual steps to verify

# Run TestSSL.sh if installed (Advanced SSL/TLS configuration testing)
if command -v testssl.sh &> /dev/null
then
    echo "Running TestSSL.sh..."
    testssl.sh $DOMAIN
else
    echo "TestSSL.sh not installed. Skipping this step."
fi

# Mixed Content Check (Manual check suggested)
echo "Checking for Mixed Content (requires manual inspection of web page elements)..."

# Automated Monitoring Setup suggestion (Manual setup required)
echo "Consider setting up automated monitoring with Uptime Robot or Site24x7 for continuous SSL monitoring."

# CRL and OCSP Check (Revocation status)
echo "Checking Certificate Revocation Status..."
openssl s_client -connect $DOMAIN:443 -servername $DOMAIN -status | grep -A 1 "OCSP Response Status"
