# inception

A containerized web infrastructure built from scratch using Docker, Docker Compose, and custom configuration scripts, following strict security and isolation constraints.

> **42 Curriculum Project:** A personal DevOps project focused on containerization, service orchestration, custom base images, and secure network topology.

## Setup & Execution

Clone the repository and launch the stack:

```bash
git clone https://github.com/yikenyiken/inception.git
cd inception
make

```

The Makefile sets up host volume directories and executes `docker-compose up --build`.

To stop the environment and remove containers:

```bash
make down

```

## Architecture & Services Provided

The stack orchestrates three core services using custom Dockerfiles built on **Alpine Linux**:

* **NGINX:** The sole public entry point. Listens on port 443 with TLS v1.2/v1.3 encryption, serving static files and routing PHP requests.
* **WordPress + PHP-FPM:** Application layer running isolated on port 9000, processing dynamic content without public network exposure.
* **MariaDB:** Relational database running on port 3306, accessible only within the internal Docker network by the WordPress container.

## User & Evaluator Guide

### 1. Accessing the Platform

* **Website:** Navigate to `https://<login>.42.fr` in your browser (requires manual `/etc/hosts` mapping of `<login>.42.fr` to `127.0.0.1`).
* **WordPress Admin Panel:** Navigate to `https://<login>.42.fr/wp-admin`.

### 2. Secrets Directory & File Structure

Sensitive environment variables and passwords are stored in flat text files inside a dedicated `secrets/` directory at the project root:

```text
├── Makefile
├── secrets/
│   ├── credentials.txt
│   ├── db_password.txt
│   └── db_root_password.txt
└── srcs/
    ├── docker-compose.yml
    └── requirements/

```

**Secret File Definitions:**

* **`secrets/db_root_password.txt`**: Contains only the raw password string for the MariaDB `root` user.
* **`secrets/db_password.txt`**: Contains only the raw password string for the non-root MariaDB user.
* **`secrets/credentials.txt`**: Defines key-value pairs for WordPress users and the database user:

```env
# wordpress database user
db_user=yiken
# admin wordpress user credentials
wp_admin_user=master
wp_admin_password=masterPasswd
# additional wordpress user credentials
wp_user=yikenyiken
wp_password=totem

```

### 3. Verifying Service Health

Check that all containers are healthy and properly routed:

```bash
# Verify all three containers are running
docker ps

# Check logs for a specific service
docker logs srcs-nginx-1
docker logs srcs-wordpress-1
docker logs srcs-mariadb-1

# Verify volume persistence on the host
ls -la /home/<login>/data/db
ls -la /home/<login>/data/www

```

## My Work & Key Engineering Decisions

* **Alpine Base Images:** Built every Dockerfile from pure Alpine Linux images without relying on pre-packaged application containers from Docker Hub.
* **Volume Persistence:** Mapped application assets and database files to dedicated host directories to guarantee data survival across container restarts.
* **Automated Provisioning:** Authored custom shell entrypoint scripts to automate database bootstrapping, user privilege setup, and WP-CLI initialization on first boot using mounted secrets.
* **Network Isolation:** Enforced strict internal networking where NGINX remains the only publicly exposed container.

## Conceptual & Engineering Highlights

### Bypassing Pre-Built Images for Custom Runtime Controls

Standard official images hide initialization logic behind internal scripts. Building custom Alpine-based Dockerfiles required writing native shell scripts to handle service lifecycles:

* **MariaDB Bootstrap:** Built initialization logic that boots the daemon in temporary mode to safely execute database creation and grant user privileges before switching to foreground execution.
* **FastCGI vs. Reverse Proxying:** Configured seamless communication between NGINX and PHP-FPM over port 9000, ensuring NGINX handles static assets directly while delegating dynamic script execution via `fastcgi_pass`.

## What I Learned

Deepened practical knowledge of system administration, container isolation, PID 1 process management, TLS/SSL certificate generation, volume management, and custom network topologies.

## Technologies

Docker · Docker Compose · NGINX · MariaDB · PHP-FPM · Alpine Linux · Bash