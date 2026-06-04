# K8s on AWS — Terraform 1-Click Deploy

## 📌 Yêu Cầu Chính

Dựng một hệ thống Kubernetes trên AWS **hoàn toàn tự động** bằng Terraform:

1. **Infrastructure**
   - 1 EC2 instance
   - Chạy minikube hoặc kind (Kubernetes cluster nhẹ)
   - Deploy 1 app đơn giản
   - Expose qua ALB (Application Load Balancer)

2. **Automation**
   - Toàn bộ phải là 1-click: `terraform apply` → xong
   - Terraform tự dựng hạ tầng + cấu hình K8s + deploy app
   - Không chạy thủ công

3. **Provider Wiring**
   - Wire ≥ 2 provider (AWS + Kubernetes, hoặc AWS + Kubernetes + Helm, v.v.)
   - Hiểu cách output của provider này trở thành input của provider khác

> **Lưu ý**: Kiến trúc, công cụ, cách wire provider, cách kết nối K8s với ALB — đó là phần **bạn tự nghiên cứu**. Không có lời giải mẫu. Lab minikube/kind trước là điểm khởi đầu.

---

## 📦 Nộp Gì?

| #   | Deliverable        | Chi tiết                                                                           |
| --- | ------------------ | ---------------------------------------------------------------------------------- |
| 1   | **Terraform code** | Repo đầy đủ, có thể chạy ngay                                                      |
| 2   | **README.md**      | - Lệnh chạy chính xác<br>- Sơ đồ kiến trúc (diagram)<br>- Giải thích wire provider |
| 3   | **Bằng chứng**     | URL ALB hoạt động (ảnh/video)                                                      |
| 4   | **Cleanup**        | `terraform destroy` dọn sạch                                                       |

---

## ✅ Điều Kiện Đạt (Acceptance Criteria)

Phải đạt **tất cả** 5 điểm:

- [ ] **1-click automation**: Chạy `terraform apply` từ repo sạch → app chạy, ALB URL work
- [ ] **K8s thực sự**: App chạy trong K8s (minikube/kind), không cài thẳng EC2
- [ ] **≥ 2 provider**: Wire ít nhất 2 provider (AWS + Kubernetes minimum)
- [ ] **Giải thích được**: Nói rõ tại sao chọn cách làm này (kiến trúc, công cụ, output→input)
- [ ] **Reproducible**: Chạy lại từ đầu được kết quả giống nhau

---

## 🔍 Cách Chấm

Trainer sẽ:

1. Clone repo của bạn
2. Chạy đúng lệnh trong README
3. Kiểm tra xem acceptance criteria có đạt không
4. Hỏi bạn giải thích thiết kế
5. Chạy `terraform destroy` để dọn sạch (tiết kiệm chi phí AWS)

---

## 🛠 Kỹ Năng Cần Dùng

- Terraform (IaC)
- AWS (EC2, ALB, VPC, Security Groups)
- Kubernetes (minikube/kind)
- Provider dependency & output wiring
- Networking & load balancing
