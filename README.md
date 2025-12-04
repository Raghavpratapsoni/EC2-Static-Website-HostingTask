# EC2 Static Resume Website

This repo deploys a static resume website on an Amazon EC2 t2.micro instance using Nginx.

Files:
- ec2_resume.tf / main.tf : Terraform infra (VPC/subnet/module + EC2)
- user-data.sh           : boot script to install nginx and deploy index.html
- my_ip_cidr.txt         : your public IP (example: 203.0.113.5/32) — do not commit sensitive IPs
- launch.ps1             : optional PowerShell one-shot launcher
- screenshots/           : required deliverable screenshots

How to run:
1. Put your public SSH key at `C:/Users/<you>/.ssh/id_rsa.pub` or change the key path in the Terraform file.
2. Edit `my_ip_cidr.txt` to contain your public IP with `/32`.
3. From the project root:
   - `terraform init`
   - `terraform plan -out plan.tfout`
   - `terraform apply "plan.tfout"`
4. Visit `http://<public-ip>/` printed by Terraform.

Hardening:
- SSH restricted to my IP in Security Group.
- Key-based SSH enforced.
- `yum-cron` enabled for automatic updates.
- Minimal open ports (only 80 and 22).

Contact: raghavpratapsoni@gmail.com
