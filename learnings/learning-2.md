## What each tool does  
```text
| Tool            | Frontend responsibility                    |  
| --------------- | ------------------------------------------ |  
| **CodeQL**      | Source-code security analysis              |  
| **Trivy FS**    | Dependencies/filesystem vulnerabilities    |  
| **Trivy Image** | Vulnerabilities in final container image   |  
| **Gitleaks**    | Secrets accidentally committed             |  
| **SonarQube**   | Code quality + bugs + security/code smells |  
| **npm audit**   | npm dependency vulnerabilities             |  
```
## Responsibility Table  
```table
| Stage        | Tool             | Workflow   | GitHub Code Scanning? |     Artifact? | Purpose                 |  
| ------------ | ---------------- | ---------- | --------------------: | ------------: | ----------------------- |  
| Source       | Gitleaks         | `01`       |                     ❌ |      Optional | Secrets                 |  
| Source       | Trivy FS         | `01`       |                     ✅ |      Optional | Dependencies/filesystem |  
| Source       | CodeQL           | `01`       |                     ✅ |      Optional | Source-code security    |  
| Source       | SonarQube        | `01`       |                     ❌ |             ❌ | Quality/SAST            |  
| Container    | Trivy Dockerfile | `02`       |                     ❌ |             ✅ | Dockerfile security     |  
| Container    | Docker build     | `02`       |                     ❌ |             ❌ | Build image             |  
| Container    | Trivy Image      | `02`       |                     ❌ |             ✅ | Image vulnerabilities   |  
| Registry     | ECR              | `02`       |                     ❌ |             ❌ | Store image             |  
| Supply chain | Cosign           | `02`       |                     ❌ |             ❌ | Sign image              |  
| Supply chain | SBOM             | `02`       |                     ❌ | ✅/attestation | Software inventory      |  
| Deployment   | GitOps           | `02`       |                     ❌ |             ❌ | Update desired state    |  
| Deployment   | ArgoCD           | Outside CI |                     ❌ |             ❌ | Deploy to EKS           |  
