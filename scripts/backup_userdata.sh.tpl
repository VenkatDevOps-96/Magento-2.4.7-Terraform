#!/bin/bash
S3_BUCKET="${s3_bucket_name}"

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
TIMESTAMP=$(date +%Y%m%d-%H%M)
AMI_NAME="magento-app-backup-${TIMESTAMP}"

# Create AMI without rebooting
/usr/bin/aws ec2 create-image --instance-id $INSTANCE_ID --name "$AMI_NAME" --no-reboot --description "AMI backup after code update"

# Optional: backup Magento files
tar -czf /tmp/magento-code-${TIMESTAMP}.tar.gz /var/www/html
/usr/bin/aws s3 cp /tmp/magento-code-${TIMESTAMP}.tar.gz s3://$S3_BUCKET/code-backups/

