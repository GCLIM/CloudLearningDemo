#install updates
yum update -y

#install php
amazon-linux-extras install -y php7.2

#install httpd
yum install -y httpd

#enable and start httpd
systemctl enable httpd
systemctl start httpd

#write index.php
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;
cd /var/www/html
cat <<EOT >>index.php
<?php
echo '<h1>2022/2023 Cloud Learning Trainers</h1>';
echo '<h2>Message: All the best with your AWS Associate Level Certification Exam and join us next year!</h2>';
echo '<img src="https://cloudlearning9-mys3bucket.s3.ap-northeast-1.amazonaws.com/myTeam.png">'; //This should echo my team image
\$instanceid = file_get_contents('http://169.254.169.254/latest/meta-data/instance-id'); // Get instance id
\$placementregion = file_get_contents('http://169.254.169.254/latest/meta-data/placement/region'); // Get placement region
echo '<p>Hosted on ',\$instanceid,'</p>';
echo '<p>AWS region ',\$placementregion,'</p>';
?>
EOT
