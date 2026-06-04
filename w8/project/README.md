# XBrain K8s Lab on AWS

Multi-AZ Kubernetes deployment on AWS using Terraform, minikube, and ALB.

## Architecture

```
Internet (port 80)
    ↓
ALB (Multi-AZ: AZ1 10.0.2.0/24 + AZ2 10.0.4.0/24)
    ↓ routes to
EC2 t3.medium (10.0.3.0/24, AZ1)
    ↓ runs
minikube + kubectl + xbrain-app pods (NodePort 30080)
    ↓
Custom "Hello XBrain" page
```

**Infrastructure:**
- AWS: VPC (10.0.0.0/16), ALB (multi-AZ), EC2, Security Groups
- Kubernetes: minikube on EC2, 2x nginx-based app pods
- Docker: Custom image (tuphucnguyen20051/xbrain-app:latest)

---

## Project Structure

```
w8/project/
├── terraform/
│   ├── main.tf              # Provider config
│   ├── vpc.tf               # VPC, subnets, IGW, routing
│   ├── ec2.tf               # EC2 instance + IAM
│   ├── alb.tf               # ALB, target group, listener
│   ├── security_groups.tf   # SG rules (SSH, HTTP, NodePort)
│   ├── kubernetes.tf        # K8s outputs
│   ├── terraform.tfvars     # Variables (region, CIDR, image)
│   └── variables.tf         # Variable definitions
├── scripts/
│   └── setup.sh             # EC2 user_data: Docker, minikube, kubectl
├── app/
│   ├── Dockerfile           # nginx + custom index.html
│   └── index.html           # React-style "Hello XBrain" UI
└── README.md
```

---

## Quick Start

### 1. Initialize
```bash
cd terraform
terraform init
```

### 2. Plan
```bash
terraform plan
```

### 3. Deploy
```bash
terraform apply -auto-approve
```
⏳ Wait 10-15 minutes (EC2 boot + minikube + pod deployment)

### 4. Access
```bash
# Get ALB URL
terraform output app_url

# Open in browser
http://<ALB-DNS>
```

---

## SSH Access

EC2 allows SSH (port 22 open):
```bash
# Get EC2 IP
EC2_IP=$(terraform output -raw ec2_public_ip 2>/dev/null || \
  aws ec2 describe-instances --filters "Name=tag:Name,Values=xbrain-k8s-lab-ec2" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' --region us-east-1 --output text)

# SSH in
ssh -i <your-key.pem> ubuntu@$EC2_IP

# Debug K8s
kubectl get pods -o wide
kubectl logs -l app=xbrain
minikube status
```

---

## Cleanup

```bash
terraform destroy -auto-approve
```

---

## Outputs

```
app_url              = "http://xbrain-k8s-lab-alb-xxx.us-east-1.elb.amazonaws.com"
alb_dns_name         = "xbrain-k8s-lab-alb-xxx.us-east-1.elb.amazonaws.com"
ec2_instance_id      = "i-xxx"
ec2_public_ip        = "x.x.x.x"
ec2_private_ip       = "10.0.3.x"
vpc_id               = "vpc-xxx"
```

---

## Customization

### Change Docker Image
Edit `terraform/terraform.tfvars`:
```hcl
docker_image = "your-username/your-image:latest"
```

Then redeploy:
```bash
terraform apply -auto-approve
```

### Modify HTML
Edit `app/index.html`, then rebuild and push:
```bash
cd app
docker build -t your-username/xbrain-app:latest .
docker push your-username/xbrain-app:latest
```

---

## Costs

- EC2 t3.medium: ~$0.04/h
- ALB: ~$0.02/h
- **Total: ~$0.06/h** (~$50/month if 24/7)

**Destroy when not in use!** 🔥

---

## Learning Outcomes

✅ AWS VPC, ALB, EC2, Security Groups
✅ Terraform multi-provider setup
✅ Kubernetes (minikube) on EC2
✅ Docker containerization
✅ Infrastructure as Code (IaC)
✅ Multi-AZ deployment patterns

---

**XBrain Phase 2 AWS Accelerator Lab**
