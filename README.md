# Inception 🐳

**A Docker-powered infrastructure project** demonstrating containerized service orchestration, system hardening, and automated deployment workflows.

## 🛠️ Tech Stack
- **Containers**: Docker, Docker Compose
- **Web Server**: NGINX (with TLS/SSL)
- **Database**: MariaDB (MySQL-compatible)
- **CMS**: WordPress (PHP-FPM)
- **Automation**: Bash scripting
- **Security**: Custom Debian images

## 🌟 Key Features
1. **Multi-service Architecture**  
   - Isolated containers for each service (NGINX, WordPress, DB)
2. **TLS Encryption**  
   - Self-signed SSL certificates for secure HTTPS traffic
3. **Persistent Storage**  
   - Docker volumes for database and WordPress data
4. **System Hardening**  
   - Minimal Debian base images  
   - Restricted user permissions  
   - Automated firewall rules (UFW)

## 🚀 Quick Start
```bash
git clone https://github.com/Nkhou/Inception/
cd Inception
docker-compose up --build
```
## 📚 Documentation
- https://hub.docker.com/_/nginx
- https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-docker/
- https://hub.docker.com/_/mariadb
- https://mariadb.com/kb/en/installing-and-using-mariadb-via-docker/
- https://mariadb.com/docs/server/connect/command-line/
- https://hub.docker.com/_/wordpress
