# Project Vault: Laboratorio di Fondamenti di Sicurezza su Azure (Fase 1)

**Leggi in:** [English](README.md) | [Español](README.es.md) | [Italiano](README.it.md)

## 🎯 Panoramica
**Project Vault** è un laboratorio Terraform su Microsoft Azure, con un ambito deliberatamente limitato. Provisiona un Resource Group, una Virtual Network segmentata, un Network Security Group con postura "deny-all" (in entrata *e* in uscita), e un Key Vault con controllo degli accessi basato su RBAC e purge protection abilitata.

Questa è la **Fase 1** di un portfolio in 3 parti che esplora l'ingegneria della sicurezza cloud. Non pretende intenzionalmente di essere un'architettura "Zero Trust" completa — dimostra i controlli fondamentali che qualsiasi ambiente Azure hardened deve prima implementare correttamente: segmentazione di rete, accesso ai segreti con privilegio minimo reale, e protezione contro l'eliminazione accidentale o malevola delle risorse.

## 💡 Perché Project Vault?
Ho costruito questo progetto per esercitarmi — e poter difendere nel dettaglio — i fondamenti del provisioning sicuro su Azure tramite Infrastructure as Code:
* **Segmentazione di rete:** regole NSG deny-all in entrambe le direzioni, non solo in entrata.
* **Gestione dei segreti con controllo degli accessi reale:** un Key Vault con purge protection attiva e un'assegnazione RBAC esplicita, non solo un vault lasciato senza protezione.
* **Riproducibilità:** l'intero ambiente è definito in Terraform versionato, quindi può essere distrutto e ricreato in modo identico.

## 🏗️ Diagramma dell'Architettura
![Architettura di Sicurezza](assets/diagrama_arquitectura.jpg)

## 🛡️ Cosa È Realmente Implementato
* **Key Vault, hardened:** `purge_protection_enabled = true` (un vault eliminato permanentemente non è recuperabile durante la finestra di soft-delete senza questo), autorizzazione RBAC abilitata, con un'assegnazione esplicita del ruolo `Key Vault Secrets Officer` — senza questo, il vault esiste ma nulla ha il permesso di leggere o scrivere segreti al suo interno.
* **Network Security Group, entrambe le direzioni:** regole allow esplicite per HTTPS (443) in entrata e in uscita, con una regola deny-all di chiusura (priorità 4096) su ciascuna direzione. Azure consente tutto il traffico in uscita per impostazione predefinita a meno che non lo si limiti — questo NSG limita entrambe le direzioni.
* **Governance via IaC:** tutte le risorse definite e versionate in Terraform; nessuna configurazione manuale da portale.

## 🔍 Analisi dei Componenti
### 1. `main.tf` — Orchestrazione
![Analisi main.tf](assets/main.png)
* Definisce il provider, il Resource Group, la VNet, la subnet e l'associazione NSG-subnet.

### 2. `security.tf` — Hardening
![Analisi security.tf](assets/security.png)
* Regole NSG (entrata + uscita, deny-all predefinito) e il Key Vault, inclusa la sua assegnazione RBAC.

### 3. `variables.tf` — Parametrizzazione
![Analisi variables.tf](assets/variables.png)
* Variabili di input (regione, ambiente, nome del progetto) con valori predefiniti sensati.

### 4. `outputs.tf` — Tracciabilità
![Analisi outputs.tf](assets/outputs.png)
* Espone il nome del Resource Group, l'ID della VNet e l'URI del Key Vault dopo il deployment.

---

## 🛠️ Tech Stack
* **Cloud:** Microsoft Azure (Resource Group, Key Vault con RBAC, Virtual Network, NSG)
* **IaC:** HashiCorp Terraform (provider `azurerm` ~> 3.0)
* **Controllo Versione:** Git (GitHub)

## 🤖 CI/CD
GitHub Actions esegue `terraform init` e `terraform validate` su ogni push/PR verso `main` — una verifica sintattica e di coerenza interna, eseguita senza backend né credenziali Azure configurate. Non esegue `plan` né `apply` contro una subscription reale.

![Terraform CI/CD](https://github.com/luis-troccoli/project-vault/actions/workflows/terraform-pipeline.yml/badge.svg)

*In questa fase non è ancora integrata alcuna scansione SAST (tfsec/checkov) — questa lacuna viene colmata in [Secure Cloud Foundation](https://github.com/luis-troccoli/secure-cloud-foundation) (Fase 2), insieme all'autenticazione federata OIDC che sostituisce le credenziali statiche.*

## 📈 Roadmap (proseguito nelle fasi successive)
* **Scansione SAST:** integrazione di `tfsec`/`checkov` — risolto nella Fase 2.
* **Autenticazione federata:** sostituire le credenziali statiche in CI con OIDC — risolto nella Fase 2.
* **Backend remoto:** Azure Storage Account con state locking, per il lavoro collaborativo.
* **Moduli riusabili:** refactoring in `/modules` — risolto nella Fase 3.

## 🚀 Guida al Deployment
1. `az login`
2. `terraform init`
3. `terraform plan`
4. `terraform apply`
5. `terraform destroy` (eseguire al termine per evitare costi indesiderati)

## 🤝 Contributi
La sicurezza è un processo continuo. Se hai esperienza in **Cloud Security** e desideri proporre miglioramenti, le **Pull Request** sono benvenute.
