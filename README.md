Technical Test Submission

This document outlines the implementation and delivery of the technical test requirements, focusing on application containerization, infrastructure provisioning, application hosting, and CI/CD pipeline setup.

---

## **1. Application Dockerization**

### **Backend Application**
- **Repository:** `ezops-br/rest-api-ezops-test`
- **Dockerfile:** A `Dockerfile` was created for containerizing the backend application.
  - Base image: `node:14`
  - Steps include installing dependencies, copying source code, and exposing the necessary port.

### **Frontend Application**
- **Repository:** `ezops-br/vuejs-ezops-test`
- **Dockerfile:** A `Dockerfile` was created for containerizing the frontend application.
  - Base image: `node:14`
  - Steps include installing dependencies, building the application, and serving it via Nginx.

### **Docker Compose**
- A `docker-compose.yaml` file was created to manage both backend and frontend services.
- **Features:**
  - Separate networks for inter-service communication.
  - Volume sharing to persist data where applicable.
  - Environment variables configured for smooth interaction.

---

## **2. Infrastructure Provisioning with Terraform**

### **Terraform Setup**
- **Remote State Management:**
  - Backend configured to use S3 for state storage and DynamoDB for state locking.
- **Modules Used:**
  - VPC creation with public and private subnets.
  - Elastic Load Balancer (ELB).
  - EC2 instances for backend hosting.
  - CloudFront distribution for frontend hosting.
  - Security Groups for resource access control

### **AWS Resources Provisioned**
- **VPC:**
  - A custom VPC with isolated public and private subnets.
  - Subnets spread across multiple availability zones for high availability.

- **Elastic Load Balancer (ELB):**
  - Configured to route traffic to backend instances.

- **EC2 Instances:**
  - One instance for Docker Compose to manage backend services.
  - One instance with Kubernetes (K0s) for backend deployment.

- **CloudFront:**
  - Configured to serve the frontend application.

- **Security Groups:**
  - Defined rules to control inbound and outbound traffic for EC2 instances, ELB, and other resources.

---

## **3. Application Hosting**

### **Backend Application**
- **Deployment:**
  - Deployed using K0s Kubernetes cluster.
  - The ELB is configured to route traffic to the backend service.

### **Frontend Application**
- **Deployment:**
  - Hosted in an S3 bucket with CloudFront distribution.
  - CNAME alias configured via Route 53.

---

## **4. CI/CD Process Using General CI/CD Tools**

### **Pipeline Overview**
- Implemented a GitHub Actions workflow to automate deployment.
- **Pipeline Steps:**
  1. **Build Stage:** Docker images for backend are built and pushed to Docker Hub.
  2. **Deploy Stage:**
     - Backend: Deployed to the Kubernetes cluster.
     - Frontend: Deployed to S3 and invalidated in CloudFront.

---

## **Deliverables**

### **Artifacts Provided**
- Dockerfiles:
  - `Dockerfile` for backend.
  - `Dockerfile` for frontend.

- Docker Compose:
  - `docker-compose.yaml`

- Terraform Code:
  - Scripts for provisioning VPC, ELB, EC2, SGs and CloudFront.

- CI/CD Pipeline Configuration:
  - GitHub Actions workflows.


---


