#how to get ec2 and region
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
REGION=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/region)
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
echo "Region: $REGION, Instance ID: $INSTANCE_ID"

##attache ebs vol dinamcically 
for letter in {f..z}; do DEVICE="/dev/sd$letter"; if ! aws ec2 describe-instances --instance-id i-xxxxxxxxxxxxxxxxx --query "Reservations[].Instances[].BlockDeviceMappings[].DeviceName" | grep -q "$DEVICE"; then aws ec2 attach-volume --volume-id vol-xxxxxxxxxxxxxxx --instance-id i-xxxxxxxxxxxxxxx --device $DEVICE; echo "Attached $DEVICE"; break; fi; done
