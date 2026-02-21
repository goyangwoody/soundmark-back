# 📦 Soundmark Backend Deployment Guide

**Stack:** FastAPI + PostgreSQL(PostGIS) + Docker Compose  
**Target:** AWS EC2 (single instance, production-ready)

---

## ✅ Architecture

```
Internet
   ↓
Nginx (80/443)
   ↓
FastAPI (8000)
   ↓
PostgreSQL + PostGIS
```

All services run on **one EC2 instance via Docker Compose**.

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [AWS EC2 Setup](#aws-ec2-setup)
3. [Server Initialization](#server-initialization)
4. [Application Deployment](#application-deployment)
5. [Post-Deployment](#post-deployment)
6. [Maintenance](#maintenance)
7. [Troubleshooting](#troubleshooting)

---

## 1️⃣ Prerequisites

### ✔ Required Credentials

Before deployment, prepare:

- **Spotify Developer Account**
  - Client ID
  - Client Secret
  - Redirect URI

- **JWT Secret Key**
  - Generate: `openssl rand -hex 32`

- **Database Password**
  - Strong password for PostgreSQL

---

## 2️⃣ AWS EC2 Setup

### ✔ Instance Configuration

| Setting          | Recommended Value      | Notes                    |
| ---------------- | ---------------------- | ------------------------ |
| AMI              | Ubuntu 22.04 LTS       | Or latest Ubuntu Server  |
| Instance Type    | t3.small               | t3.micro for demo only   |
| Storage          | 20GB gp3               | SSD recommended          |
| Security Group   | See below              | -                        |

### ✔ Security Group Rules

| Type  | Protocol | Port Range | Source    | Description      |
| ----- | -------- | ---------- | --------- | ---------------- |
| SSH   | TCP      | 22         | Your IP   | SSH access       |
| HTTP  | TCP      | 80         | 0.0.0.0/0 | Web traffic      |
| HTTPS | TCP      | 443        | 0.0.0.0/0 | Secure traffic   |

**Security Notes:**
- Restrict SSH (port 22) to your IP only
- Use key-based authentication, disable password login
- Consider using AWS Systems Manager Session Manager instead of SSH

### ✔ Elastic IP (Optional but Recommended)

Allocate and associate an Elastic IP to your instance for a stable public IP address.

---

## 3️⃣ Server Initialization

### Step 1: Connect to EC2

```bash
ssh -i your-key.pem ubuntu@YOUR_EC2_PUBLIC_IP
```

### Step 2: Update System

```bash
sudo apt update
sudo apt upgrade -y
```

### Step 3: Install Docker

```bash
# Install Docker
sudo apt install -y docker.io docker-compose

# Add user to docker group
sudo usermod -aG docker ubuntu

# Enable Docker to start on boot
sudo systemctl enable docker

# Log out and back in for group changes to take effect
exit
```

### Step 4: Reconnect and Verify

```bash
ssh -i your-key.pem ubuntu@YOUR_EC2_PUBLIC_IP
docker --version
docker-compose --version
```

### Step 5: Add Swap (Recommended for t3.micro/small)

```bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Make swap permanent
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

### Step 6: Configure Firewall (Optional)

```bash
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable
```

---

## 4️⃣ Application Deployment

### Step 1: Clone Repository

```bash
cd ~
git clone https://github.com/YOUR_USERNAME/soundmark-back.git
cd soundmark-back
```

### Step 2: Configure Environment Variables

```bash
# Copy example environment file
cp .env.example .env

# Edit with your credentials
nano .env
```

**Required Configuration:**

```bash
# Database
POSTGRES_PASSWORD=your_secure_database_password_here

# Spotify (from Spotify Developer Dashboard)
SPOTIFY_CLIENT_ID=your_spotify_client_id
SPOTIFY_CLIENT_SECRET=your_spotify_client_secret
SPOTIFY_REDIRECT_URI=http://YOUR_EC2_PUBLIC_IP/api/v1/auth/spotify/callback

# JWT (generate: openssl rand -hex 32)
JWT_SECRET_KEY=your_32_character_minimum_secret_key

# CORS (your frontend domain)
ALLOWED_ORIGINS=http://YOUR_FRONTEND_DOMAIN,https://YOUR_FRONTEND_DOMAIN

# Application
DEBUG=false
```

**Important:**
- Update `DATABASE_URL` with the same password you set in `POSTGRES_PASSWORD`
- Generate a strong JWT secret key
- Update `SPOTIFY_REDIRECT_URI` with your actual domain
- Set `DEBUG=false` for production

Save and exit (Ctrl+X, then Y, then Enter).

### Step 3: Build and Start Services

```bash
# Build and start all services
docker-compose -f docker-compose.prod.yml up -d --build

# Check if all containers are running
docker-compose -f docker-compose.prod.yml ps
```

Expected output:
```
NAME                COMMAND                  SERVICE   STATUS    PORTS
soundmark-api       "uvicorn app.main:ap…"   api       running
soundmark-db        "docker-entrypoint.s…"   db        running
soundmark-nginx     "/docker-entrypoint.…"   nginx     running   0.0.0.0:80->80/tcp
```

### Step 4: Run Database Migrations

```bash
# Wait a few seconds for DB to be ready, then run migrations
docker-compose -f docker-compose.prod.yml exec api alembic upgrade head
```

### Step 5: Verify Deployment

```bash
# Check logs
docker-compose -f docker-compose.prod.yml logs api

# Check if API is responding
curl http://localhost/docs
```

Visit in browser:
```
http://YOUR_EC2_PUBLIC_IP/docs
```

You should see the FastAPI Swagger documentation.

---

## 5️⃣ Post-Deployment

### ✔ Health Check

Test the following endpoints:

- **API Documentation:** `http://YOUR_EC2_PUBLIC_IP/docs`
- **Health Check:** `http://YOUR_EC2_PUBLIC_IP/health` (if implemented)

### ✔ SSL/HTTPS Setup (Recommended)

For production, configure SSL using Let's Encrypt:

1. **Point domain to your EC2:**
   - Create an A record pointing to your EC2 Elastic IP

2. **Install Certbot:**
```bash
sudo apt install -y certbot python3-certbot-nginx
```

3. **Update nginx configuration for SSL:**

Create `nginx.ssl.conf`:

```nginx
events {
    worker_connections 1024;
}

http {
    upstream api {
        server api:8000;
    }

    # HTTP -> HTTPS redirect
    server {
        listen 80;
        server_name your-domain.com;
        return 301 https://$server_name$request_uri;
    }

    # HTTPS server
    server {
        listen 443 ssl http2;
        server_name your-domain.com;

        ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;

        client_max_body_size 20m;
        client_body_timeout 120s;

        location / {
            proxy_pass http://api;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            
            proxy_connect_timeout 60s;
            proxy_send_timeout 60s;
            proxy_read_timeout 60s;
        }
    }
}
```

4. **Get SSL certificate:**
```bash
sudo certbot certonly --standalone -d your-domain.com
```

5. **Mount certificate in docker-compose:**

Update `docker-compose.prod.yml` nginx service:

```yaml
  nginx:
    image: nginx:alpine
    container_name: soundmark-nginx
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.ssl.conf:/etc/nginx/nginx.conf:ro
      - /etc/letsencrypt:/etc/letsencrypt:ro
    depends_on:
      - api
    restart: always
```

6. **Restart services:**
```bash
docker-compose -f docker-compose.prod.yml down
docker-compose -f docker-compose.prod.yml up -d
```

### ✔ Auto-renewal for SSL

```bash
# Test renewal
sudo certbot renew --dry-run

# Set up auto-renewal (cron job)
sudo crontab -e
```

Add this line:
```
0 3 * * * certbot renew --quiet --post-hook "docker-compose -f /home/ubuntu/soundmark-back/docker-compose.prod.yml restart nginx"
```

---

## 6️⃣ Maintenance

### 📊 Monitoring Logs

```bash
# View all logs
docker-compose -f docker-compose.prod.yml logs

# Follow logs in real-time
docker-compose -f docker-compose.prod.yml logs -f

# View specific service logs
docker-compose -f docker-compose.prod.yml logs api
docker-compose -f docker-compose.prod.yml logs db
docker-compose -f docker-compose.prod.yml logs nginx
```

### 🔄 Updating the Application

```bash
# Navigate to project directory
cd ~/soundmark-back

# Pull latest code
git pull origin main

# Rebuild and restart
docker-compose -f docker-compose.prod.yml up -d --build

# Run migrations
docker-compose -f docker-compose.prod.yml exec api alembic upgrade head
```

### 💾 Database Backup

```bash
# Create backup directory
mkdir -p ~/backups

# Backup database
docker-compose -f docker-compose.prod.yml exec db pg_dump -U soundmark soundmark_db > ~/backups/backup_$(date +%Y%m%d_%H%M%S).sql

# Verify backup
ls -lh ~/backups/
```

**Automated daily backups:**

```bash
# Create backup script
nano ~/backup.sh
```

Add:
```bash
#!/bin/bash
BACKUP_DIR=~/backups
DATE=$(date +%Y%m%d_%H%M%S)
cd ~/soundmark-back
docker-compose -f docker-compose.prod.yml exec -T db pg_dump -U soundmark soundmark_db > $BACKUP_DIR/backup_$DATE.sql
# Keep only last 7 days
find $BACKUP_DIR -name "backup_*.sql" -mtime +7 -delete
```

Make executable and add to cron:
```bash
chmod +x ~/backup.sh
crontab -e
```

Add:
```
0 2 * * * /home/ubuntu/backup.sh
```

### 🔄 Database Restore

```bash
# Stop API to prevent connections
docker-compose -f docker-compose.prod.yml stop api

# Restore from backup
cat ~/backups/backup_YYYYMMDD_HHMMSS.sql | docker-compose -f docker-compose.prod.yml exec -T db psql -U soundmark soundmark_db

# Restart API
docker-compose -f docker-compose.prod.yml start api
```

### 🔧 Restart Services

```bash
# Restart all services
docker-compose -f docker-compose.prod.yml restart

# Restart specific service
docker-compose -f docker-compose.prod.yml restart api
docker-compose -f docker-compose.prod.yml restart db
docker-compose -f docker-compose.prod.yml restart nginx
```

### 🛑 Stop Services

```bash
# Stop all services
docker-compose -f docker-compose.prod.yml down

# Stop and remove volumes (⚠️ deletes database data)
docker-compose -f docker-compose.prod.yml down -v
```

---

## 7️⃣ Troubleshooting

### ❌ Common Issues

#### 1. API Container Crashes

**Check logs:**
```bash
docker-compose -f docker-compose.prod.yml logs api
```

**Common causes:**
- Missing environment variables
- Database connection issues
- Invalid JWT secret key

**Solution:**
- Verify `.env` file has all required variables
- Check `DATABASE_URL` matches `POSTGRES_PASSWORD`
- Ensure JWT_SECRET_KEY is at least 32 characters

#### 2. Database Connection Fails

**Check if database is running:**
```bash
docker-compose -f docker-compose.prod.yml ps db
docker-compose -f docker-compose.prod.yml logs db
```

**Test connection:**
```bash
docker-compose -f docker-compose.prod.yml exec db psql -U soundmark -d soundmark_db -c "SELECT 1;"
```

**Solution:**
- Wait longer for DB to initialize (especially first time)
- Check database credentials in `.env`
- Verify `depends_on` health check in docker-compose

#### 3. Nginx Cannot Reach API

**Check if API is running:**
```bash
docker-compose -f docker-compose.prod.yml exec nginx ping api
curl http://localhost:8000/docs
```

**Solution:**
- Verify all containers are on the same Docker network
- Check nginx.conf proxy_pass points to `http://api:8000`

#### 4. Port Already in Use

**Find process using port 80:**
```bash
sudo lsof -i :80
```

**Solution:**
```bash
# Stop conflicting service (e.g., Apache)
sudo systemctl stop apache2
sudo systemctl disable apache2
```

#### 5. Out of Memory

**Check memory usage:**
```bash
free -h
docker stats
```

**Solution:**
- Add swap (see Server Initialization)
- Upgrade to larger instance type
- Reduce number of uvicorn workers in docker-compose

#### 6. Migration Fails

**Error:** "Target database is not up to date"

**Solution:**
```bash
# Check current migration version
docker-compose -f docker-compose.prod.yml exec api alembic current

# View migration history
docker-compose -f docker-compose.prod.yml exec api alembic history

# Upgrade to latest
docker-compose -f docker-compose.prod.yml exec api alembic upgrade head
```

### 📊 Health Check Commands

```bash
# Check all containers status
docker-compose -f docker-compose.prod.yml ps

# Check Docker resource usage
docker stats

# Check disk space
df -h

# Check system memory
free -h

# Test API endpoint
curl http://localhost/docs

# Check if services are listening
sudo netstat -tulpn | grep LISTEN
```

---

## ⚠️ Security Checklist

- [ ] Changed default database password
- [ ] Generated secure JWT secret key (32+ characters)
- [ ] Set `DEBUG=false` in production
- [ ] Restricted SSH access to specific IP
- [ ] Configured firewall (UFW)
- [ ] Using HTTPS with SSL certificate
- [ ] Regular security updates: `sudo apt update && sudo apt upgrade`
- [ ] Set up automated backups
- [ ] Configured CORS with specific domains (not `*`)
- [ ] Using Elastic IP for stable address
- [ ] Monitoring logs regularly

---

## 📊 Performance Optimization

### For Production Workloads:

1. **Increase uvicorn workers:**
   ```yaml
   # In docker-compose.prod.yml
   command: uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 4
   ```

2. **Add Redis for caching (optional):**
   - Session storage
   - API response caching
   - Rate limiting

3. **Database connection pooling:**
   - Already configured in SQLAlchemy
   - Adjust pool size in `database.py` if needed

4. **Upgrade instance type:**
   - t3.medium or larger for production
   - Consider RDS for database if scaling up

---

## 🎯 Summary

✅ **Deployed:**
- FastAPI application
- PostgreSQL with PostGIS
- Nginx reverse proxy
- All services containerized with Docker

✅ **Configured:**
- Environment-based configuration
- Database migrations
- Health checks
- Restart policies

✅ **Ready for:**
- Production traffic
- Easy updates via Git + Docker
- Automated backups
- SSL/HTTPS setup

---

## 📞 Support

**If deployment issues persist:**

1. Check CloudWatch logs (if configured)
2. Review security group rules
3. Verify all environment variables
4. Check Docker container logs
5. Ensure sufficient disk space and memory

**Useful commands for debugging:**
```bash
# Full system check
docker-compose -f docker-compose.prod.yml ps
docker-compose -f docker-compose.prod.yml logs --tail=50
df -h
free -h
sudo systemctl status docker
```

---

**Last Updated:** 2026-02-21  
**Tested On:** Ubuntu 22.04 LTS, Docker 24.0+, Docker Compose 2.0+
