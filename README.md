# terraform-wordpress-on-aws

Using terraform to deploy WordPress on AWS with a LAMP stack.

3 tier architecture(web, app and DB).

Site data is stored inside an RDS database.

Database password stored securely with Secrets Manager .

Auto Scaling Group used to provision multiple servers in HA mode.

Used user-data to install WordPress on servers

Load Balancer used to distribute requests across multiple web servers

Route53 along with Amazon Certificate Manager used to connect to the website securely(SSL) via user-friendly DNS names
