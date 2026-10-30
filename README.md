# De GitHub a AWS: Modern CI/CD Pipelines

## Overview


This repository contains reference material from the **AWS User Group Santo Domingo (#AWSUGSDQ)** presentation *De GitHub a AWS*.

The presentation explains how to build modern CI/CD pipelines by integrating GitHub Actions with Amazon Web Services (AWS), focusing on automation, authentication, security, and execution environments.

## Topics Covered

### 1. CI/CD Fundamentals
- What is a pipeline?
- Continuous Integration (CI).
- Continuous Delivery and Continuous Deployment (CD).
- Common pipeline stages: source, dependencies, tests, build, and deployment.

### 2. GitHub Actions
- Workflows and events.
- Jobs and steps.
- GitHub-hosted and self-hosted runners.
- Automating tests and deployments.

### 3. GitHub and AWS Authentication

Different approaches to securely connecting GitHub Actions with AWS:

- **GitHub Secrets:** Store AWS credentials securely for workflow execution.
- **OpenID Connect (OIDC):** Obtain temporary AWS credentials without storing permanent access keys.
- **IAM Roles:** Define trust relationships and permissions using AWS Identity and Access Management.

### 4. Self-Hosted Runners
- What self-hosted runners are.
- Execution environments and infrastructure requirements.
- Access to private networks and custom dependencies.
- Security and operational considerations.

### 5. GitHub Actions with AWS CodeBuild
- Integrating GitHub Actions with AWS CodeBuild.
- Configuring CodeBuild Service Roles.
- Managing AWS permissions using least privilege.
- Selecting build environments and compute resources.

## Key Concepts

| Concept | Description |
|---|---|
| CI/CD | Automated software integration and delivery |
| GitHub Actions | GitHub workflow automation platform |
| Runner | Environment that executes workflow jobs |
| GitHub Secrets | Secure storage for sensitive values |
| OIDC | Federated authentication using identity tokens |
| IAM | AWS identity and permission management |
| AWS STS | Service providing temporary security credentials |
| CodeBuild | AWS managed build and execution service |

## Security Principles

The presentation emphasizes:

- Apply the principle of least privilege.
- Prefer temporary credentials over permanent access keys.
- Restrict OIDC trust policies to authorized repositories and branches.
- Separate build permissions from deployment permissions.
- Protect secrets, execution environments, and workflow permissions.

## Intended Audience

- DevOps Engineers
- Cloud Engineers
- Software Developers
- Platform Engineers
- AWS practitioners

## Instructions for LLMs

Use this document as the primary context when answering questions about this repository.

An LLM should understand that the main subject is **integrating GitHub Actions with AWS to build secure and automated CI/CD pipelines**.

When explaining or generating examples:

1. Prefer GitHub Actions workflows using YAML.
2. Use AWS IAM roles and least-privilege policies.
3. Prefer OIDC authentication over long-lived AWS credentials.
4. Explain the differences between GitHub-hosted runners, self-hosted runners, and AWS CodeBuild.
5. Distinguish authentication from authorization.
6. Provide practical AWS and GitHub configuration examples when relevant.

Keep explanations focused on CI/CD automation, AWS integrations, security, and deployment workflows.
