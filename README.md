# Kube Single Master (UTM)

This project provides an automated way to deploy a functional Kubernetes cluster on **Apple Silicon Macbooks** using **UTM**. It is specifically designed for a lightweight setup spanning two laptops (1 Master node and 1 Worker node), making it ideal for local development and testing.

## Overview

Unlike high-availability multi-master clusters, this project emphasizes efficiency and simplicity for local environments. It automates the entire process from VM creation to the installation of critical cluster components.

### Key Features
- **Mac-Native Virtualization**: Uses UTM for seamless VM management on M1/M2/M3 chips.
- **Automated Provisioning**: Ansible playbooks handle the OS preparation, Kubernetes initialization, and networking.
- **Cloud-Integrated Backup**: Terraform-managed AWS S3 integration for Longhorn volume backups.
- **Full-Stack Components**: Pre-configured installations for:
  - **ArgoCD**: GitOps-based deployments.
  - **MetalLB**: Load balancing for local services.
  - **Cert-Manager**: Automated TLS certificate management.
  - **Longhorn**: Distributed block storage with S3 backup support.
  - **Ingress-Nginx**: Traffic routing and SSL termination.

## Core Components Structure

- `/ansible`: Playbooks and tasks for K8s setup and component configuration.
- `/terraform`: AWS infrastructure for S3 backups and retention policies.
- `/mac-vms`: Shell scripts for automated UTM VM creation (`vm-master.sh`, `vm-worker.sh`).

## Prerequisites

- Two Macbooks with UTM installed.
- SSH access between laptops.
- AWS CLI configured (for S3 backup integration).

## Getting Started

1. **Infrastructure**: Navigate to `/terraform` and run `terraform apply` to create the S3 bucket.
2. **VM Creation**: Use the scripts in `/mac-vms` to spin up your master and worker nodes.
3. **Inventory**: Copy `inventory.ini.example` to `inventory.ini` and update with your VM IP addresses.
4. **Deploy**: Run the main setup script:
   ```bash
   ./setup.sh
   ```

## Management

The cluster is managed via ArgoCD. Once deployed, you can access the ArgoCD UI and begin deploying your applications using GitOps.

## License
MIT
