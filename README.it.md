# Project Vault: Architettura Azure Hardened sotto il modello Zero Trust

**Leggi in:** [English](README.md) | [Español](README.es.md) | [Italiano](README.it.md)

## 🎯 Panoramica
**Project Vault** è un'implementazione di infrastruttura critica su **Microsoft Azure** progettata seguendo il paradigma **Security by Design**. Centralizziamo la governance degli asset in una codebase **Terraform** immutabile, verificabile e scalabile, eliminando le configurazioni manuali soggette a errori.

## 💡 Perché Project Vault?
Ho creato questo progetto per dimostrare la mia capacità di implementare ambienti cloud professionali. Con **Project Vault**, intendo convalidare ed esibire la mia padronanza in:
* **Sicurezza:** Applicazione pratica dei principi *Zero Trust* e *Least Privilege*.
* **Automazione:** Padronanza dell'*Infrastructure as Code* (IaC) per eliminare l'intervento umano e garantire coerenza.
* **DevSecOps:** Integrazione di workflow CI/CD che garantiscono la verifica della sicurezza prima, durante e dopo il deployment.
Questo repository è il mio "laboratorio di best practice", dove dimostro come trasformare requisiti di sicurezza astratti in un'architettura tecnica funzionale, manutenibile e pronta per la produzione.

## 🏗️ Diagramma dell'Architettura
![Architettura di Sicurezza](assets/diagrama_arquitectura.jpg)

## 🛡️ Pilastri Strategici di Sicurezza
* **Gestione Centralizzata dei Segreti:** Integrazione di **Azure Key Vault** per astrarre il ciclo di vita delle credenziali.
* **Segmentazione di Rete:** **NSG** con politica "Deny All", consentendo solo il traffico strettamente necessario.
* **Governance via IaC:** Tracciabilità totale delle modifiche tramite controllo versione.

## 🔍 Analisi dei Componenti (Infrastructure as Code)
Ho strutturato il progetto seguendo le migliori pratiche di modularità, separando la logica in quattro blocchi chiave:

### 1. `main.tf` - Orchestrazione
![Analisi main.tf](assets/main.png)
* **Funzione:** Definisce il deployment principale e l'interconnessione delle risorse Azure, fungendo da punto di ingresso logico dell'intera architettura.

### 2. `security.tf` - Hardening
![Analisi security.tf](assets/security.png)
* **Funzione:** Centralizza la logica dei **Network Security Groups (NSG)** e le policy di accesso al **Key Vault**, mantenendo le regole di sicurezza isolate dal codice di provisioning generale.

### 3. `variables.tf` - Parametrizzazione
![Analisi variables.tf](assets/variables.png)
* **Funzione:** Definisce le variabili di input (nomi, regioni, SKU), consentendo all'infrastruttura di essere riutilizzabile in diversi ambienti (Dev/Staging/Prod) senza modificare il codice principale.

### 4. `outputs.tf` - Tracciabilità
![Analisi outputs.tf](assets/outputs.png)
* **Funzione:** Espone dati critici post-deployment (ID delle risorse, URL degli endpoint), facilitando l'integrazione con altri servizi e la validazione immediata dello stato finale.

---

## 🛠️ Tech Stack
Questo progetto utilizza un ecosistema moderno focalizzato sul cloud e la sicurezza:
* **Cloud:** Microsoft Azure (Resource Group, Key Vault, Virtual Network, NSG).
* **IaC:** HashiCorp Terraform (v1.x).
* **Sicurezza:** Architettura Zero Trust, IAM granulare, Network Security Groups.
* **CI/CD:** GitHub Actions (Automated Workflows).
* **Controllo Versione:** Git (GitHub).

## 🤖 Ciclo di Vita DevSecOps (CI/CD)
La qualità del codice è garantita tramite **GitHub Actions**, implementando **Shift-Left Security**:

![Terraform CI/CD](https://github.com/luis-troccoli/project-vault/actions/workflows/terraform-pipeline.yml/badge.svg)

## 📈 Roadmap di Scalabilità
* **Backend Remoto:** Migrazione ad *Azure Storage Account* con state locking per il lavoro collaborativo.
* **Moduli Riusabili:** Refactoring per standardizzare deployment su ambienti multipli.
* **Analisi SAST:** Integrazione automatica di `tfsec` o `checkov` per la scansione delle vulnerabilità in fase di compilazione.

## 🚀 Guida al Deployment
1. `az login`
2. `terraform init`
3. `terraform plan`
4. `terraform apply`
5. `terraform destroy` (eseguire al termine per evitare costi indesiderati)

## 🤝 Contributi
La sicurezza è un processo continuo. Se hai esperienza in **Cloud Security** e desideri proporre miglioramenti, le **Pull Request** sono benvenute.