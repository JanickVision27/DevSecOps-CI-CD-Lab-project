# DevSecOps CI/CD Lab

A proof-of-concept demonstrating a secure CI/CD pipeline with automated security scanning.

## What this lab proves

| Tool | What it does |
|---|---|
| GitHub Actions | Automated build, test, and security scan on every push to main |
| CodeQL | Static code analysis to find vulnerabilities in Java source code |
| Trivy (fs scan) | Scans source dependencies for known CVEs |
| Trivy (image scan) | Scans the Docker image for OS-level and library vulnerabilities |
| Dependabot | Automated weekly PRs for dependency updates (Maven, Actions, Docker) |
| Docker | Multi-stage build, non-root user, health check via Actuator |

## Pipeline flow

```
Push to main
  → Build & Test (Maven)
  → CodeQL code scan
  → Trivy filesystem scan
  → Build Docker image
  → Trivy image scan
  → (If all pass) ready for deployment
```

## Run locally

```bash
# Build
mvn clean package

# Run
java -jar target/lab-0.0.1-SNAPSHOT.jar

# Docker
docker build -t devsecops-lab .
docker run -p 8080:8080 devsecops-lab
```

## Health check

```bash
curl http://localhost:8080/actuator/health
```

## Security decisions

- **Multi-stage Docker build**: build dependencies stay in stage 1, only the JRE and JAR reach the final image
- **Non-root user**: the container runs as `appuser`, not root
- **exit-code 0 on Trivy**: this lab reports findings without failing the pipeline. In production, set `exit-code: 1` to block deployments on critical vulnerabilities
- **Pinned action versions**: CodeQL v3 and Trivy v0.36.0 are pinned (no floating `@master` refs); Dependabot will flag updates
