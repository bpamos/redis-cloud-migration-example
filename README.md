# Redis Cloud Migration Example (Terraform + RIOTX)

This project demonstrates a fully automated Terraform-based setup to migrate data from **AWS ElastiCache Redis** (standalone and clustered) to **Redis Cloud** using [RIOTX](https://github.com/redis-field-engineering/riotx-dist).

The current implementation provisions:
- ✅ A new AWS VPC, subnets, and security groups
- ✅ ElastiCache Redis (both standalone and clustered)
- ✅ A Redis Cloud subscription, database, and VPC peering with AWS
- ✅ An EC2 instance with Redis OSS and RIOTX pre-installed

> Next step: run **RIOTX migration commands** to replicate data from ElastiCache → Redis Cloud

---

## 🔧 Requirements

- [Terraform](https://www.terraform.io/downloads)
- AWS credentials (via environment or AWS config)
- A Redis Cloud account and API key
- An SSH keypair in your target AWS region

---

## 🚀 Quick Start

### 1. Clone the repo

```bash
git clone https://github.com/bpamos/redis-cloud-migration-example.git
cd redis-cloud-migration-example
2. Configure variables
Create a terraform.tfvars file based on the example:

bash
Copy
Edit
cp terraform.tfvars.example terraform.tfvars
Update the placeholder values (e.g. Redis Cloud API keys, AWS account ID, SSH IP, etc.).

📦 What Gets Deployed
On terraform apply, the following components are created:

Component	Description
VPC + Subnets	Isolated AWS network for Redis + EC2
Security Groups	Access rules for EC2, Redis, and SSH
ElastiCache	Standalone and clustered Redis setups
Redis Cloud	Subscription, DB, and VPC networking
Peering	VPC peering between AWS and Redis Cloud
EC2 instance	With Redis OSS and RIOTX installed

🧠 RIOTX Setup (Already Installed)
Once the EC2 instance is running:

bash
Copy
Edit
ssh -i ~/.ssh/redis-migration-us-west-2.pem ec2-user@<EC2_PUBLIC_IP>
Verify installation:

bash
Copy
Edit
riotx --version
redis-server --version
🔄 Next Step: Run Migration
You can manually or automatically run:

bash
Copy
Edit
riotx replicate \
  --source redis://<elasticache-endpoint>:6379 \
  --target redis://<redis-cloud-endpoint>:6379 \
  --mode live
Replace placeholders with real Redis URIs.

A Terraform null_resource to trigger this automatically is the next enhancement (coming soon).

🧹 Cleanup
To destroy all provisioned infrastructure:

bash
Copy
Edit
terraform destroy
📁 Project Structure
text
Copy
Edit
.
├── main.tf                    # Root module
├── terraform.tfvars.example  # Variable template
├── modules/                  # All major resources as modules
│   ├── vpc/
│   ├── security_group/
│   ├── elasticache/
│   ├── rediscloud/
│   ├── rediscloud_peering/
│   └── ec2_riot/