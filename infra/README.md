# DevSecOps Pipeline Setup

Complete setup guide for Spring Petclinic DevSecOps pipeline with Jenkins, SonarQube, OWASP ZAP, Prometheus, and Grafana.

## Prerequisites

### Required Software
- **Docker**
- **VirtualBox**
- **Vagrant**
- **Git**
- **curl** (for API calls)

## Docker Images Used

| Service | Image | Purpose |
|---------|-------|---------|
| Jenkins | `jenkins:lts-jdk21` | CI/CD Pipeline |
| SonarQube | `sonarqube:community` | Code Quality Analysis |
| Prometheus | `prom/prometheus:latest` | Metrics Collection |
| Grafana | `grafana/grafana:latest` | Monitoring Dashboard |
| OWASP ZAP | `zaproxy/zap-stable` | Security Testing |
| Node Exporter | `prom/node-exporter:latest` | System Metrics |

## Quick Setup

### 1. Clone Repository
```bash
git clone <repository-url>
cd spring-petclinic-devops/infra
```

### 2. Start Infrastructure
```bash
./auto_script.sh
```

### 3. Wait for Services
- **SonarQube**: ~2-3 minutes
- **Jenkins**: ~1-2 minutes  
- **Grafana/Prometheus**: ~30 seconds

## Access URLs & Credentials

### Jenkins
- **URL**: http://localhost:8080
- **Username**: `admin`
- **Password**: `devops@2025` (or check auto_script.sh output)

### SonarQube
- **URL**: http://localhost:9000
- **Username**: `admin`
- **Password**: `admin`

### Grafana
- **URL**: http://localhost:3000
- **Username**: `admin`
- **Password**: `admin`

### Prometheus
- **URL**: http://localhost:9090
- **No authentication required**

### OWASP ZAP
- **URL**: http://localhost:8090
- **API Key**: `75de1195e318543b38c48682180e3480698a3973ad0488ee0e23d92f6061dae5`

## Pipeline Steps

### 1. Trigger Build
- Navigate to Jenkins → **spring-petclinic** job
- Click **Build Now**

### 2. Pipeline Stages
1. **Checkout** - Git clone
2. **Test** - Unit tests with JUnit
3. **SonarQube Analysis** - Code quality scan
4. **Security Scan** - OWASP ZAP testing  
5. **Build** - Maven package
6. **Deploy to Staging** - Ansible deployment (VM)
7. **Deploy to Production** - Final deployment (VM)

### 3. Monitor Progress
- **Build logs**: Jenkins console output
- **Code quality**: SonarQube dashboard
- **System metrics**: Grafana dashboards
- **Security results**: OWASP ZAP reports

## Deployment URLs

### Staging Environment
- **URL**: http://192.168.56.201:8080
- **VM**: petclinic-stage

### Production Environment  
- **URL**: http://192.168.56.200:8080
- **VM**: petclinic-prod

## Success Verification

✅ All containers running: `docker-compose ps`  
✅ Jenkins accessible with correct password  
✅ SonarQube shows "UP" status  
✅ Grafana displays system metrics  
✅ Pipeline builds successfully  
✅ Application deployed to VMs