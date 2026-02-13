# cloud-1

An Infrastructure-as-Code project that combines `Terraform` and `Ansible` to automate the deployment of a complete WordPress stack on AWS. The project provisions EC2 infrastructure, configures the server, and deploys a containerized application—all from a single command.

### Architecture

**Infrastructure Layer (Terraform):**
- AWS VPC with public subnet
- EC2 t3.micro instance (Ubuntu)
- Security groups (SSH restricted, HTTPS public)
- Internet Gateway and routing

**Configuration Layer (Ansible):**
- System updates and Docker installation
- Application file deployment
- Service orchestration

**Application Layer (Docker Compose):**
- **MariaDB**: Database backend with automated initialization
- **WordPress**: CMS with WP-CLI for setup automation
- **phpMyAdmin**: Web-based database management at `/phpmyadmin/`
- **Nginx**: SSL/TLS reverse proxy (HTTPS only)

### Usage

```bash
# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Deploy infrastructure and application
terraform apply

# Destroy infrastructure
terraform destroy
```

```bash
# Access the server (output provided after apply)
ssh -i /path/to/key.pem ubuntu@<public_ip>
```

### Configuration

1. Copy the template variables file:
   ```bash
   cp template.terraform.tfvars terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your AWS credentials and configuration:
   - AWS access key and secret key
   - SSH key pair name
   - Allowed SSH IP address
   - Domain name

3. Ensure your SSH private key is available at the path specified in `main.tf`

### Project Structure

```
cloud-1/
├── main.tf                      # Main Terraform configuration
├── cloud-1.tf                   # AWS infrastructure resources
├── template.terraform.tfvars    # Template for variables
├── playbook/
│   ├── playbook.yml            # Ansible orchestration
│   └── roles/
│       ├── docker/             # Docker installation
│       ├── copy_files/         # Application file transfer
│       ├── app/                # MariaDB, WordPress, phpMyAdmin
│       └── nginx/              # Reverse proxy setup
└── README.md
```

### Security Features

- SSH access restricted to specific IP address
- HTTPS only (TLS 1.2/1.3)
- Self-signed SSL certificate
- Secure credential management via environment variables
- MariaDB security hardening

### Network Flow

```
Internet → AWS Security Group → Nginx (HTTPS:443)
                                    ↓
                            ┌───────┴────────┐
                            ↓                ↓
                    WordPress:80      phpMyAdmin:80
                            ↓                ↓
                            └────→ MariaDB:3306
```

## Grading

This project is part of my curriculum at 42 School.

- **Date of completion:** 2026-02-02
- **Grade:** 100/100
