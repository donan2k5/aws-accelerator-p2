# K8s on AWS — Terraform 1-Click Deploy — Implementation Plan

## 📋 Project Scope

Build a complete Kubernetes system on AWS with:
- VPC + Private subnet for EC2
- EC2 running minikube
- K8s Deployment with NodePort service
- ALB + Target Group routing traffic to NodePort
- Simple HTML app "Hello XBrain" with nice UI

---

## 🎯 Architecture Overview

```
Internet
  ↓
ALB (port 80)
  ↓
Target Group → EC2:30080 (NodePort)
  ↓
minikube cluster
  ↓
K8s Service (NodePort:30080)
  ↓
Deployment → Pods (nginx:latest + custom HTML)
```

---

## 📦 Project Structure

```
w8/project/
├── terraform/
│   ├── main.tf                 # Provider configs + locals
│   ├── vpc.tf                  # VPC, subnets, NAT Gateway, route tables
│   ├── security_groups.tf      # Security groups (EC2, ALB)
│   ├── ec2.tf                  # EC2 instance + user_data (minikube setup)
│   ├── kubernetes.tf           # K8s provider + deployment + service
│   ├── alb.tf                  # ALB + Target Group + Listener
│   ├── variables.tf            # Input variables
│   ├── outputs.tf              # Outputs (ALB DNS, etc)
│   └── terraform.tfvars        # Variable values
├── app/
│   ├── index.html              # Hello XBrain custom HTML/CSS
│   └── Dockerfile              # (optional) if building custom image
├── README.md                    # Run instructions + architecture diagram
├── plan.md                      # This file
└── de-bai.md                    # Project assignment (English)
```

---

## 🔧 Implementation Steps

### **Step 1: VPC & Networking**
- Create VPC (10.0.0.0/16)
- Create private subnet (10.0.1.0/24) for EC2
- Create public subnet (10.0.2.0/24) for ALB
- Create Internet Gateway
- Create NAT Gateway (in public subnet) for EC2 to reach internet
- Create route tables + routes

**File:** `vpc.tf`

---

### **Step 2: Security Groups**
- **EC2 Security Group:**
  - Ingress: port 22 (SSH) from anywhere (for debugging)
  - Ingress: port 30080 (NodePort) from ALB security group
  - Egress: all

- **ALB Security Group:**
  - Ingress: port 80 (HTTP) from anywhere
  - Egress: port 30080 to EC2 security group

**File:** `security_groups.tf`

---

### **Step 3: EC2 Instance + Minikube Setup**
- Launch t3.medium EC2 in private subnet
- User data script to:
  - Install Docker
  - Install minikube
  - Start minikube
  - Configure kubeconfig for Terraform access

**File:** `ec2.tf`

---

### **Step 4: Kubernetes Provider + Deployment**
- Configure Kubernetes provider (connect to minikube on EC2)
- Create K8s Deployment (nginx:latest + custom HTML)
- Create K8s Service (NodePort:30080)
- Wire EC2 output (IP) to K8s provider input

**File:** `kubernetes.tf`

---

### **Step 5: ALB + Load Balancing**
- Create ALB (in public subnet)
- Create Target Group (port 30080, target=EC2 instance)
- Create Listener (ALB port 80 → Target Group)
- Health checks on port 30080

**File:** `alb.tf`

---

### **Step 6: Outputs & Documentation**
- Output ALB DNS name
- Output EC2 IP
- Output app URL
- Create README.md with:
  - Run commands
  - Architecture diagram
  - Provider wiring explanation
  - Cleanup instructions

**Files:** `outputs.tf`, `README.md`

---

## 🎨 App Details

### **HTML App (index.html)**
- Simple "Hello XBrain" with:
  - Nice CSS styling (gradient, animations)
  - Responsive design
  - Show some info (pod name, timestamp, etc if possible)
  - Colors: XBrain theme (professional)

### **Docker Image**
- Use `nginx:latest` as base
- Copy custom HTML to `/usr/share/nginx/html/`
- Port: 80 (inside container)

---

## 🔌 Provider Wiring

**Wire 3 providers:**

1. **AWS Provider** → creates VPC, EC2, ALB
2. **Kubernetes Provider** → connects to minikube on EC2
   - Input: `host = aws_instance.ec2.private_ip` ← WIRE from AWS
   - Manages K8s resources (Deployment, Service)
3. **(Optional) Helm Provider** → if using Helm for deployment
   - Input: kubernetes config from K8s provider

**Minimum requirement:** AWS + Kubernetes (2 providers)

---

## ⚙️ Assumptions & Defaults

| Setting | Value | Notes |
|---------|-------|-------|
| **AWS Region** | us-east-1 | Can be changed in variables |
| **Instance Type** | t3.medium | Enough for minikube + app |
| **K8s** | minikube | Lightweight, runs in Docker |
| **App Image** | nginx:latest | Simple, fast to pull |
| **NodePort** | 30080 | Fixed, in NodePort range (30000-32767) |
| **ALB Port** | 80 | HTTP only (for simplicity) |
| **VPC CIDR** | 10.0.0.0/16 | Standard private range |
| **Private Subnet** | 10.0.1.0/24 | EC2 here |
| **Public Subnet** | 10.0.2.0/24 | NAT Gateway + ALB here |

---

## ✅ Acceptance Criteria Check

- [ ] `terraform apply` from clean repo → app runs
- [ ] ALB URL (DNS name) works in browser
- [ ] App shows "Hello XBrain" with nice styling
- [ ] App running in K8s (verify with `kubectl get pods`)
- [ ] 2+ providers wired (AWS + Kubernetes minimum)
- [ ] `terraform destroy` cleans up everything
- [ ] README explains architecture + provider wiring

---

## 🚀 Next Steps

1. Create directory structure
2. Start with `main.tf` (provider configs)
3. Build VPC layer (`vpc.tf`)
4. Build security groups (`security_groups.tf`)
5. Setup EC2 + minikube (`ec2.tf`)
6. Configure K8s provider (`kubernetes.tf`)
7. Build ALB (`alb.tf`)
8. Add outputs (`outputs.tf`)
9. Create README + diagram
10. Test: `terraform init → apply → verify`
11. Document in README
12. Cleanup: `terraform destroy`

---

## 📝 Notes

- EC2 in **private subnet** = more realistic, needs NAT Gateway (costs ~$0.045/hour)
- If budget is concern, can move EC2 to public subnet (saves NAT Gateway cost)
- Health checks must point to port 30080 (NodePort), not port 80
- K8s provider needs SSH/kubeconfig access to EC2 (user_data must setup this)
- Consider adding security best practices (e.g., restrict ALB ingress to specific IPs)

