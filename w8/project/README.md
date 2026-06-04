# XBrain K8s on AWS

Deploy K8s app trên AWS với Terraform + Helm + ALB.

## Kiến trúc

```
Internet (port 80)
    ↓
ALB (Public Subnet 1: 10.0.2.0/24)
    ↓ routes to
EC2 (Public Subnet 2: 10.0.3.0/24)
    ↓ runs
minikube + Helm + nginx pods (NodePort 30080)
    ↓
"Hello XBrain" page
```

**Providers:**
- AWS: VPC, subnets, EC2, ALB
- Helm: Deploy K8s Deployment + Service

---

## Cấu trúc

```
w8/project/
├── terraform/        # Terraform configs
├── scripts/setup.sh  # EC2 setup (Docker, minikube, Helm)
├── helm-chart/       # K8s Deployment + Service
├── app/              # index.html + Dockerfile
└── README.md
```

---

## Chạy (4 bước)

### 1. Init
```bash
cd terraform
terraform init
```

### 2. Plan
```bash
terraform plan
```

### 3. Apply
```bash
terraform apply
```
⏳ Chờ 10-15 phút (EC2 + minikube + Helm deploy)

### 4. Access
```bash
# Lấy URL
terraform output app_url

# Mở browser
http://<ALB-DNS-NAME>
```

✅ Thấy "Hello XBrain"

---

## Dọn dẹp

```bash
terraform destroy
```

---

## Outputs

```
app_url           = "http://xbrain-k8s-lab-alb-xxx.us-east-1.elb.amazonaws.com"
ec2_instance_id   = "i-xxx"
ec2_private_ip    = "10.0.3.x"
helm_release_name = "xbrain"
```

---

## Debug

```bash
# Check EC2 logs
terraform output deployment_status
# → tail -f /var/log/cloud-init-output.log (trên EC2)

# Check Helm
helm list
helm status xbrain

# Check K8s
kubectl get pods,svc
```

---

## Chi phí

- EC2 t3.medium: ~$0.04/h
- ALB: ~$0.02/h
- **Total: ~$0.06/h** (~$50/tháng nếu chạy 24/7)

**Nhớ destroy khi không dùng!** 🔥

---

## Học được gì

✅ AWS VPC + ALB + EC2
✅ Terraform providers (AWS + Helm)
✅ Kubernetes + Helm
✅ Infrastructure as Code

---

**Built for XBrain Phase 2 AWS Accelerator**
