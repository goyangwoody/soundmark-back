# 🚀 Quick Start - EC2 Deployment

This is a condensed version of the full [DEPLOYMENT.md](DEPLOYMENT.md). For detailed explanations, see the full guide.

---

## Prerequisites

- AWS EC2 instance (Ubuntu 22.04, t3.small+)
- Security group: ports 22, 80, 443 open
- Spotify Developer credentials
- Domain name (optional, for SSL)

---

## 1. Prepare EC2 Instance

```bash
# SSH into your EC2
ssh -i your-key.pem ubuntu@YOUR_EC2_IP

# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
sudo apt install -y docker.io docker-compose
sudo usermod -aG docker ubuntu
sudo systemctl enable docker

# Add swap (for t3.micro/small)
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Log out and back in
exit
```

---

## 2. Deploy Application

```bash
# SSH back in
ssh -i your-key.pem ubuntu@YOUR_EC2_IP

# Clone repository
git clone https://github.com/YOUR_USERNAME/soundmark-back.git
cd soundmark-back

# Configure environment
cp .env.example .env
nano .env
```

**Update these values in .env:**
```bash
POSTGRES_PASSWORD=your_secure_password
SPOTIFY_CLIENT_ID=your_client_id
SPOTIFY_CLIENT_SECRET=your_client_secret
SPOTIFY_REDIRECT_URI=http://YOUR_EC2_IP/api/v1/auth/spotify/callback
JWT_SECRET_KEY=$(openssl rand -hex 32)  # Generate this
ALLOWED_ORIGINS=http://your-frontend-domain.com
DEBUG=false
```

**Important:** Update `DATABASE_URL` with the same password as `POSTGRES_PASSWORD`:
```bash
DATABASE_URL=postgresql+asyncpg://soundmark:your_secure_password@db:5432/soundmark_db
```

Save and exit (Ctrl+X, Y, Enter).

```bash
# Start services
docker-compose -f docker-compose.prod.yml up -d --build

# Wait 30 seconds, then run migrations
docker-compose -f docker-compose.prod.yml exec api alembic upgrade head

# Check status
docker-compose -f docker-compose.prod.yml ps
docker-compose -f docker-compose.prod.yml logs api
```

---

## 3. Verify

Visit: `http://YOUR_EC2_IP/docs`

You should see FastAPI Swagger documentation.

---

## Common Commands

```bash
# View logs
docker-compose -f docker-compose.prod.yml logs -f

# Restart services
docker-compose -f docker-compose.prod.yml restart

# Update application
git pull origin main
docker-compose -f docker-compose.prod.yml up -d --build
docker-compose -f docker-compose.prod.yml exec api alembic upgrade head

# Backup database
docker-compose -f docker-compose.prod.yml exec db pg_dump -U soundmark soundmark_db > backup.sql

# Stop services
docker-compose -f docker-compose.prod.yml down
```

---

## Troubleshooting

**API won't start:**
```bash
docker-compose -f docker-compose.prod.yml logs api
# Check .env file has all required variables
# Verify DATABASE_URL matches POSTGRES_PASSWORD
```

**Can't access from browser:**
- Check EC2 security group allows port 80
- Verify nginx is running: `docker-compose -f docker-compose.prod.yml ps nginx`

**Out of memory:**
```bash
free -h  # Check if swap is active
docker stats  # Check container memory usage
```

---

## SSL Setup (Optional)

**After pointing your domain to EC2:**

```bash
# Install Certbot
sudo apt install -y certbot python3-certbot-nginx

# Get certificate
sudo certbot certonly --standalone -d your-domain.com

# Update nginx config to use SSL (see DEPLOYMENT.md)
# Update docker-compose to mount SSL certificates
# Restart services
```

---

## File Structure Reference

```
soundmark-back/
├── .env                        # Your secrets (DO NOT COMMIT)
├── .env.example                # Template for .env
├── docker-compose.prod.yml     # Production compose file
├── nginx.conf                  # Nginx configuration
├── Dockerfile                  # Container build instructions
├── requirements.txt            # Python dependencies
├── alembic.ini                 # Database migration config
├── DEPLOYMENT.md               # Full deployment guide
└── app/                        # Application code
```

---

## Security Checklist

- [ ] Changed `POSTGRES_PASSWORD` from default
- [ ] Generated secure `JWT_SECRET_KEY` (32+ chars)
- [ ] Set `DEBUG=false`
- [ ] Set specific `ALLOWED_ORIGINS` (not `*`)
- [ ] Restricted SSH to your IP in security group
- [ ] Using Elastic IP for EC2
- [ ] SSL certificate installed (for production)

---

**Need help?** See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed troubleshooting and advanced configuration.
