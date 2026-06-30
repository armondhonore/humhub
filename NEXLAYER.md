# Nexlayer — humhub

<!-- nexlayer:meta version=1 analyzed=2026-06-29T23:45:55Z repo=https://github.com/armondhonore/humhub branch=nexlayer -->

> **For AI agents (Claude Code, Cursor, Gemini CLI, Copilot):**
> This file is the **project context** for this Nexlayer deployment — tech stack, env vars, secrets, live URL.
> For full platform detail (nexlayer.yaml schema, Dockerfile rules, CI/CD, task recipes) read **`nexlayer.skills`** in this repo.
>
> **Critical rules (full detail in `nexlayer.skills`):**
> - Inter-pod refs: `${podName:port}` only — never `localhost` or bare hostnames
> - Docker Hub images: prefix with `mirror.gcr.io/library/` — bare tags fail on the cluster
> - Secrets: set in the Nexlayer dashboard — never commit to `nexlayer.yaml` or Dockerfile
>
> **This file:** `agent-managed` sections update automatically. `user-editable` sections (Local Development Setup, Nexlayer Deployment Plan, Build Notes) are yours — preserved across re-analysis.

## Project Summary
<!-- nexlayer:section agent-managed=project_summary -->
HumHub is an open-source social network software designed for organizations to create their own private social platforms. It is built on the Yii PHP framework and supports modular extensions for community management.
<!-- nexlayer:end -->

## Technology Stack
<!-- nexlayer:section agent-managed=tech_stack -->
| Name | Kind | Version | Detected From |
|------|------|---------|---------------|
| PHP | language | 8.x | .env.example |
| Yii | framework | 2.x | .env.example |
| MySQL | database | 8.0 | .env.example |
| Redis | infra | 7.0 | .env.example |
<!-- nexlayer:end -->

## Repository Structure
<!-- nexlayer:section agent-managed=structure_map -->
- .env.example — Environment configuration templates for DB, Redis, and Mailer
<!-- nexlayer:end -->

## External Services Required
<!-- nexlayer:section agent-managed=external_deps -->
Services that must be configured separately (not deployed by Nexlayer):

- SMTP Mail Server
<!-- nexlayer:end -->

## Local Development Setup
<!-- nexlayer:section user-editable=local_setup -->
### Prerequisites

- PHP >= 8.0
- MySQL/MariaDB
- Redis
- Apache/Nginx

### Environment variables

Copy `.env.example` to `.env.local` and fill in:

```
HUMHUB_CONFIG__COMPONENTS__DB__DSN=mysql:host=localhost;dbname=humhub
HUMHUB_CONFIG__COMPONENTS__REDIS__HOSTNAME=localhost
HUMHUB_CONFIG__COMPONENTS__REDIS__PORT=6379
```

### Steps

1. `composer install` — Install PHP dependencies
2. `php yii migrate` — Run database migrations
3. `php yii install` — Initialize the application

<!-- nexlayer:end -->

## Nexlayer Setup
<!-- nexlayer:section agent-managed=nexlayer_setup -->
### nexlayer.yaml

```yaml
application:
  name: humhub
  pods:
    web:
      image: "registry.nexlayer.io/user_01kece1xyh817dwff7wnarhkxd/humhub:9f15d2a-fix5"
      path: /
      port: 80
      servicePorts:
        - 80
      env:
        HUMHUB_CONFIG__COMPONENTS__DB__DSN: "mysql:host=${podName:mysql:3306};dbname=humhub"
        HUMHUB_CONFIG__COMPONENTS__DB__USERNAME: "${env:DB_USER}"
        HUMHUB_CONFIG__COMPONENTS__DB__PASSWORD: "${env:DB_PASSWORD}"
        HUMHUB_CONFIG__COMPONENTS__REDIS__HOSTNAME: "${podName:redis:6379}"
      depends_on:
        - mysql
        - redis
services:
  mysql:
    image: mirror.gcr.io/library/mysql:8.0
    path: /
    port: 3306
    servicePorts:
      - 3306
    env:
      MYSQL_ROOT_PASSWORD: "${env:DB_ROOT_PASSWORD}"
      MYSQL_DATABASE: "humhub"
      MYSQL_USER: "${env:DB_USER}"
      MYSQL_PASSWORD: "${env:DB_PASSWORD}"
  redis:
    image: mirror.gcr.io/library/redis:7.0
    path: /
    port: 6379
    servicePorts:
      - 6379
```
<!-- nexlayer:end -->

## Nexlayer Deployment Plan
<!-- nexlayer:section user-editable=deployment_plan -->
### Pod Topology

| Pod | Image | Port | Role |
|-----|-------|------|------|
| humhub-web | mirror.gcr.io/library/php:8.2-apache | 80 | web |
| humhub-db | mirror.gcr.io/library/mysql:8.0 | 3306 | database |
| humhub-redis | mirror.gcr.io/library/redis:alpine | 6379 | cache |

### Deployment notes

- The web pod connects to the database via humhub-db.pod:3306
- The web pod connects to the cache via humhub-redis.pod:6379
- Following Nexlayer rules, MySQL and Redis are isolated in their own pods.

<!-- nexlayer:end -->

## Build Notes
<!-- nexlayer:section user-editable=build_notes -->
<!-- Add notes for future builds here — preserved across re-analysis -->
<!-- nexlayer:end -->

## Nexlayer Configuration
<!-- nexlayer:section agent-managed=nexlayer_config -->
**Last deployed:** 2026-06-30T00:11:31Z  
**Live URL:** https://relaxed-weasel-humhub.cloud.nexlayer.ai  
**Runtime:**  · **Port:** auto-detected  
**Deploy branch:** nexlayer  

```yaml
application:
  name: humhub
  pods:
    web:
      image: "registry.nexlayer.io/user_01kece1xyh817dwff7wnarhkxd/humhub:9f15d2a-fix5"
      path: /
      port: 80
      servicePorts:
        - 80
      env:
        HUMHUB_CONFIG__COMPONENTS__DB__DSN: "mysql:host=${podName:mysql:3306};dbname=humhub"
        HUMHUB_CONFIG__COMPONENTS__DB__USERNAME: "${env:DB_USER}"
        HUMHUB_CONFIG__COMPONENTS__DB__PASSWORD: "${env:DB_PASSWORD}"
        HUMHUB_CONFIG__COMPONENTS__REDIS__HOSTNAME: "${podName:redis:6379}"
      depends_on:
        - mysql
        - redis
services:
  mysql:
    image: mirror.gcr.io/library/mysql:8.0
    path: /
    port: 3306
    servicePorts:
      - 3306
    env:
      MYSQL_ROOT_PASSWORD: "${env:DB_ROOT_PASSWORD}"
      MYSQL_DATABASE: "humhub"
      MYSQL_USER: "${env:DB_USER}"
      MYSQL_PASSWORD: "${env:DB_PASSWORD}"
  redis:
    image: mirror.gcr.io/library/redis:7.0
    path: /
    port: 6379
    servicePorts:
      - 6379
```
<!-- nexlayer:end -->

## Build History
<!-- nexlayer:section agent-managed=build_history -->
| Date | Status | Notes |
|------|--------|-------|
| 2026-06-29T23:59:41Z | analyzed | initial repo analysis |
| 2026-06-30T00:11:31Z | success | deployed https://relaxed-weasel-humhub.cloud.nexlayer.ai |
<!-- nexlayer:end -->

