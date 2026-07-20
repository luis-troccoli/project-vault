# Project Vault: Laboratorio de Fundamentos de Seguridad en Azure (Fase 1)

**Leer en:** [English](README.md) | [Español](README.es.md) | [Italiano](README.it.md)

## 🎯 Visión General
**Project Vault** es un laboratorio de Terraform en Microsoft Azure, deliberadamente acotado en su alcance. Provisiona un Resource Group, una Virtual Network segmentada, un Network Security Group con postura "deny-all" (en entrada *y* salida), y un Key Vault con control de acceso basado en RBAC y purge protection habilitado.

Esta es la **Fase 1** de un portfolio de 3 partes explorando ingeniería de seguridad cloud. Intencionalmente no afirma ser una "arquitectura Zero Trust" completa — demuestra los controles fundamentales que cualquier entorno Azure hardened necesita resolver primero: segmentación de red, acceso a secretos con mínimo privilegio real, y protección contra borrado accidental o malicioso de recursos.

## 💡 ¿Por qué Project Vault?
Construí esto para practicar — y poder defender en detalle — los fundamentos del provisioning seguro en Azure vía Infrastructure as Code:
* **Segmentación de red:** reglas NSG deny-all en ambas direcciones, no solo en entrada.
* **Gestión de secretos con control de acceso real:** un Key Vault con purge protection activo y una asignación RBAC explícita, no solo un vault desprotegido.
* **Reproducibilidad:** todo el entorno está definido en Terraform versionado, así que puede destruirse y recrearse de forma idéntica.

## 🏗️ Diagrama de Arquitectura
![Arquitectura de Seguridad](assets/diagrama_arquitectura.jpg)

## 🛡️ Lo que Realmente Está Implementado
* **Key Vault, hardened:** `purge_protection_enabled = true` (un vault eliminado permanentemente no es recuperable durante la ventana de soft-delete sin esto), autorización RBAC habilitada, con una asignación explícita del rol `Key Vault Secrets Officer` — sin esto, el vault existe pero nada tiene permiso de leer o escribir secretos en él.
* **Network Security Group, ambas direcciones:** reglas allow explícitas para HTTPS (443) en entrada y salida, con una regla deny-all de cierre (prioridad 4096) en cada dirección. Azure permite todo el tráfico de salida por defecto a menos que lo restrinjas — este NSG restringe ambas direcciones.
* **Gobernanza vía IaC:** todos los recursos definidos y versionados en Terraform; sin configuración manual desde el portal.

## 🔍 Análisis de Componentes
### 1. `main.tf` — Orquestación
![Análisis del main.tf](assets/main.png)
* Define el provider, el Resource Group, la VNet, la subnet y la asociación NSG-subnet.

### 2. `security.tf` — Hardening
![Análisis del security.tf](assets/security.png)
* Reglas NSG (entrada + salida, deny-all por defecto) y el Key Vault, incluyendo su asignación RBAC.

### 3. `variables.tf` — Parametrización
![Análisis del variables.tf](assets/variables.png)
* Variables de entrada (región, entorno, nombre del proyecto) con valores por defecto razonables.

### 4. `outputs.tf` — Trazabilidad
![Análisis del outputs.tf](assets/outputs.png)
* Expone el nombre del Resource Group, el ID de la VNet y el URI del Key Vault tras el despliegue.

---

## 🛠️ Tech Stack
* **Cloud:** Microsoft Azure (Resource Group, Key Vault con RBAC, Virtual Network, NSG)
* **IaC:** HashiCorp Terraform (provider `azurerm` ~> 3.0)
* **Control de Versiones:** Git (GitHub)

## 🤖 CI/CD
GitHub Actions ejecuta `terraform init` y `terraform validate` en cada push/PR a `main` — una verificación de sintaxis y consistencia interna, ejecutada sin backend ni credenciales de Azure configuradas. No ejecuta `plan` ni `apply` contra una suscripción real.

![Terraform CI/CD](https://github.com/luis-troccoli/project-vault/actions/workflows/terraform-pipeline.yml/badge.svg)

*Todavía no hay escaneo SAST (tfsec/checkov) integrado en esta fase — ese hueco se cierra en [Secure Cloud Foundation](https://github.com/luis-troccoli/secure-cloud-foundation) (Fase 2), junto con autenticación federada OIDC reemplazando credenciales estáticas.*

## 📈 Roadmap (continúa en fases siguientes)
* **Escaneo SAST:** integración de `tfsec`/`checkov` — resuelto en la Fase 2.
* **Autenticación federada:** reemplazar credenciales estáticas en CI con OIDC — resuelto en la Fase 2.
* **Backend remoto:** Azure Storage Account con bloqueo de estado, para trabajo colaborativo.
* **Módulos reutilizables:** refactorización a `/modules` — resuelto en la Fase 3.

## 🚀 Guía de Despliegue
1. `az login`
2. `terraform init`
3. `terraform plan`
4. `terraform apply`
5. `terraform destroy` (una vez hayas terminado, para evitar costos indeseados)

## 🤝 Contribución
La seguridad es un proceso continuo. Si tienes experiencia en **Cloud Security** y deseas proponer mejoras, los **Pull Requests** son bienvenidos.
