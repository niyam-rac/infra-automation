### README.md

# Automating Infrastructure Deployment

## Project Overview

This repository is dedicated to automating the deployment of infrastructure using Infrastructure as Code (IaC). This project aims to manage the deployment of two key services: **Payment Service** and **Contact Service**. Each service is deployed to its own **Resource Group** and is housed in separate **Azure Function Apps**. The tools utilized in this project include **Azure DevOps**, **Terraform**, and **DevOps** practices.

## Key Terminologies

- **Infrastructure as Code (IaC)**: A practice in DevOps where infrastructure is provisioned and managed using code rather than manual processes.
- **Azure DevOps**: A set of tools for software development and collaboration, including continuous integration and continuous deployment (CI/CD).
- **Terraform**: A tool for automating the deployment of cloud infrastructure using configuration files.
- **Resource Group**: A container for managing related Azure resources.
- **Function App**: A serverless platform for running event-driven applications.

## Project Components

### 1. **Payment Service**
- A service designed to handle payment processing.
- Deployed in its own **Resource Group** and **Function App**.

### 2. **Contact Service**
- A service designed to handle contact management.
- Deployed in a separate **Resource Group** and **Function App**.

## Tools Used

### 1. **Azure DevOps**
- Used to set up the continuous integration and continuous deployment (CI/CD) pipelines for the services.

### 2. **Terraform**
- Used to automate the provisioning of Azure resources such as Function Apps, Resource Groups, and any other necessary infrastructure.

### 3. **DevOps Practices**
- Implements practices like continuous integration (CI), continuous deployment (CD), and monitoring to ensure smooth, automated deployment processes.

## Steps to Set Up

1. **Set Up Azure DevOps Project**: Create a project in Azure DevOps for tracking and managing the CI/CD pipeline.
2. **Configure Terraform**: Initialize Terraform to manage the infrastructure and resources.
3. **Create Resource Groups and Function Apps**: Use Terraform to provision the required resources for both services in separate resource groups.
4. **Set Up CI/CD Pipeline**: Configure Azure DevOps pipelines for both services to automatically build and deploy upon changes.

---

### Terminologies Tracker

1. **Infrastructure as Code (IaC)**  
2. **Azure DevOps**  
3. **Terraform**  
4. **Resource Group**  
5. **Function App**  
6. **CI/CD**  
7. **Payment Service**  
8. **Contact Service**

