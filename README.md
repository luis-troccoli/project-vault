# Project Vault: Azure Hardened Architecture under Zero Trust Model

**Read this in:** [English](README.md) | [Español](README.es.md) | [Italiano](README.it.md)

## 🎯 Overview
**Project Vault** is a critical infrastructure implementation in **Microsoft Azure** designed under the **Security by Design** paradigm. We centralize asset governance into an immutable, auditable, and scalable **Terraform** codebase, eliminating error-prone manual configurations.

## 💡 Why Project Vault?
I created this project as a technical demonstration of my ability to implement professional cloud environments. With **Project Vault**, I aim to validate and showcase my mastery in:
* **Security:** Practical application of *Zero Trust* and *Least Privilege* principles.
* **Automation:** Mastery of *Infrastructure as Code* (IaC) to eliminate human intervention and ensure consistency.
* **DevSecOps:** Integration of CI/CD workflows that ensure security is verified before, during, and after deployment.
This repository is my "best practices laboratory," where I demonstrate how to transform abstract security requirements into a functional, maintainable, and production-ready technical architecture.

## 🏗️ Architecture Diagram
![Security Architecture](assets/diagrama_arquitectura.jpg)

## 🛡️ Strategic Security Pillars
* **Centralized Secret Management:** Integration of **Azure Key Vault** to abstract the credential lifecycle.
* **Network Segmentation:** **NSG** with "Deny All" posture, allowing only strictly necessary traffic.
* **IaC Governance:** Total traceability of changes through version control.

## 🔍 Component Analysis (Infrastructure as Code)
I have structured the project following modularity best practices, separating the logic into four key blocks:

### 1. `main.tf` - Orchestration
![main.tf Analysis](assets/main.png)
* **Function:** Defines the main deployment and resource interconnection in Azure, serving as the logical entry point for the entire architecture.

### 2. `security.tf` - Hardening
![security.tf Analysis](assets/security.png)
* **Function:** Centralizes **Network Security Group (NSG)** logic and **Key Vault** access policies, keeping security rules isolated from the general provisioning code.

### 3. `variables.tf` - Parameterization
![variables.tf Analysis](assets/variables.png)
* **Function:** Defines input variables (names, regions, SKUs), allowing the infrastructure to be reusable across different environments (Dev/Staging/Prod) without modifying the core code.

### 4. `outputs.tf` - Traceability
![outputs.tf Analysis](assets/outputs.png)
* **Function:** Exposes critical post-deployment data (resource IDs, endpoint URLs), facilitating integration with other services and immediate validation of the final state.

---

## 🛠️ Tech Stack
This project uses a modern ecosystem focused on cloud and security:
* **Cloud:** Microsoft Azure (Resource Group, Key Vault, Virtual Network, NSG).
* **IaC:** HashiCorp Terraform (v1.x).
* **Security:** Zero Trust Architecture, Granular IAM, Network Security Groups.
* **CI/CD:** GitHub Actions (Automated Workflows).
* **Version Control:** Git (GitHub).

## 🤖 DevSecOps Lifecycle (CI/CD)
Code quality is ensured via **GitHub Actions**, implementing **Shift-Left Security**:

![Terraform CI/CD](https://github.com/luis-troccoli/project-vault/actions/workflows/terraform-pipeline.yml/badge.svg)

## 📈 Scalability Roadmap
* **Remote Backend:** Migration to *Azure Storage Account* with state locking for collaborative work.
* **Reusable Modules:** Refactoring to standardize multi-environment deployments.
* **SAST Analysis:** Automatic integration of `tfsec` or `checkov` for vulnerability scanning at compile time.

## 🚀 Deployment Guide
1. `az login`
2. `terraform init`
3. `terraform plan`
4. `terraform apply`
5. `terraform destroy` (run once finished to avoid unwanted costs)

## 🤝 Contribution
Security is a continuous process. If you have experience in **Cloud Security** and would like to propose improvements, **Pull Requests** are welcome.