# Project Vault: Azure Security Fundamentals Lab (Phase 1)

**Read this in:** [English](README.md) | [Español](README.es.md) | [Italiano](README.it.md)

## 🎯 Overview
**Project Vault** is a small, deliberately scoped Terraform lab in Microsoft Azure. It provisions a Resource Group, a segmented Virtual Network, a default-deny Network Security Group (inbound *and* outbound), and a Key Vault with RBAC-based access control and purge protection enabled.

This is **Phase 1** of a 3-part portfolio exploring cloud security engineering. It intentionally does not claim to be a full "Zero Trust architecture" — it demonstrates the foundational controls that any hardened Azure environment needs to get right first: network segmentation, least-privilege secret access, and protection against accidental or malicious resource deletion.

## 💡 Why Project Vault?
I built this to practice — and be able to defend in detail — the fundamentals of secure Azure provisioning via Infrastructure as Code:
* **Network segmentation:** default-deny NSG rules in both directions, not just inbound.
* **Secret management with actual access control:** a Key Vault that has purge protection on and an explicit RBAC role assignment, not just a vault sitting there unprotected.
* **Reproducibility:** the entire environment is defined in version-controlled Terraform, so it can be destroyed and recreated identically.

## 🏗️ Architecture Diagram
![Security Architecture](assets/diagrama_arquitectura.jpg)

## 🛡️ What's Actually Implemented
* **Key Vault, hardened:** `purge_protection_enabled = true` (a permanently deleted vault is not recoverable during the soft-delete window without this), RBAC authorization enabled, with an explicit `Key Vault Secrets Officer` role assignment — without this, the vault exists but nothing has permission to read or write secrets to it.
* **Network Security Group, both directions:** explicit allow rules for HTTPS (443) inbound and outbound, with a deny-all catch-all rule (priority 4096) on each direction. Azure allows all outbound traffic by default unless you restrict it — this NSG restricts both.
* **IaC governance:** all resources defined and versioned in Terraform; no manual portal configuration.

## 🔍 Component Breakdown
### 1. `main.tf` — Orchestration
![main.tf Analysis](assets/main.png)
* Defines the provider, Resource Group, VNet, subnet, and the NSG-to-subnet association.

### 2. `security.tf` — Hardening
![security.tf Analysis](assets/security.png)
* NSG rules (inbound + outbound, default-deny) and the Key Vault, including its RBAC role assignment.

### 3. `variables.tf` — Parameterization
![variables.tf Analysis](assets/variables.png)
* Input variables (region, environment, project name) with sane defaults.

### 4. `outputs.tf` — Traceability
![outputs.tf Analysis](assets/outputs.png)
* Exposes the Resource Group name, VNet ID, and Key Vault URI post-deployment.

---

## 🛠️ Tech Stack
* **Cloud:** Microsoft Azure (Resource Group, Key Vault with RBAC, Virtual Network, NSG)
* **IaC:** HashiCorp Terraform (`azurerm` provider ~> 3.0)
* **Version Control:** Git (GitHub)

## 🤖 CI/CD
GitHub Actions runs `terraform init` and `terraform validate` on every push/PR to `main` — a syntax and internal-consistency check, run without backend or Azure credentials configured. It does not run `plan` or `apply` against a live subscription.

![Terraform CI/CD](https://github.com/luis-troccoli/project-vault/actions/workflows/terraform-pipeline.yml/badge.svg)

*No SAST/security scanning (tfsec/checkov) is integrated yet in this phase — that gap is closed in [Secure Cloud Foundation](https://github.com/luis-troccoli/secure-cloud-foundation) (Phase 2), along with federated OIDC authentication replacing static credentials.*

## 📈 Roadmap (carried into later phases)
* **SAST scanning:** `tfsec`/`checkov` integration — addressed in Phase 2.
* **Federated auth:** replace static credentials in CI with OIDC — addressed in Phase 2.
* **Remote backend:** Azure Storage Account with state locking, for collaborative work.
* **Reusable modules:** refactor into `/modules` — addressed in Phase 3.

## 🚀 Deployment Guide
1. `az login`
2. `terraform init`
3. `terraform plan`
4. `terraform apply`
5. `terraform destroy` (run once finished to avoid unwanted costs)

## 🤝 Contribution
Security is a continuous process. If you have experience in **Cloud Security** and would like to propose improvements, **Pull Requests** are welcome.
