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

# Install NFS client
apt-get update
apt-get install -y nfs-common

# Mount EFS
mkdir -p /mnt/efs
mount -t nfs4 -o nfsvers=4.1 ${EFS_DNS_NAME}:/ /mnt/efs

# Ensure it remounts on reboot
echo "${EFS_DNS_NAME}:/ /mnt/efs nfs4 defaults,_netdev 0 0" >> /etc/fstab

# Prepare Magento directories on EFS
mkdir -p /mnt/efs/media /mnt/efs/var

# Stop Magento or related services here if needed (optional)

# Move existing media and var contents to EFS if first time
rsync -a /var/www/html/media/ /mnt/efs/media/
rsync -a /var/www/html/var/ /mnt/efs/var/

# Rename existing dirs and create symlinks
mv /var/www/html/media /var/www/html/media.bak
mv /var/www/html/var /var/www/html/var.bak

ln -s /mnt/efs/media /var/www/html/media
ln -s /mnt/efs/var /var/www/html/var

# Set correct permissions (adjust user/group as needed)
chown -R www-data:www-data /mnt/efs/media /mnt/efs/var

# Restart web server or PHP-FPM to pick up changes (optional)
systemctl restart nginx
# or
systemctl restart php8.2-fpm
