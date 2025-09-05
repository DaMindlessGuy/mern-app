# Task 1: Docker Compose Starter (MERN + Mongo + Mongo Express + Nginx HTTPS)

This bundle runs your MERN app with **four containers**:
- **client** (React build served via `serve`)
- **api** (Express)
- **mongo** (MongoDB 7)
- **mongo-express** (DB UI)
- **nginx** (HTTPS reverse proxy to client, `/api`, and `/mongo-express`)

> Meets Task 1 requirements: four containers, internal network, volumes, env vars, HTTPS via Nginx; demo steps below align with marking and screenshot guidance.

## 1) Prereqs (AWS VM, no GUI)
Install Docker & Compose on the VM (Ubuntu example):
```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu   $(. /etc/os-release && echo $VERSION_CODENAME) stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
newgrp docker
```

## 2) Place these files in your repo root
```
repo/
  docker-compose.yml
  .env
  certs/            # generated below
  nginx/nginx.conf
  client/Dockerfile
  server/Dockerfile
  scripts/gen-certs.sh
```

Copy `.env.example` to `.env` and update values:
```bash
cp .env.example .env
# Important: set a strong password and set REACT_APP_YOUR_HOSTNAME=https://<PUBLIC_HOST_OR_IP>/api
```

## 3) Generate HTTPS certs
Use your **public DNS or IP** as CN so the browser shows the correct hostname:
```bash
bash scripts/gen-certs.sh <EC2-PUBLIC-DNS-OR-IP>
# e.g. bash scripts/gen-certs.sh ec2-1-2-3-4.ap-southeast-2.compute.amazonaws.com
```

## 4) Build & run
```bash
docker compose up -d --build
docker compose ps
docker logs -f api
```

## 5) URLs to test (and screenshot)
- App: `https://<PUBLIC_HOST_OR_IP>/`
- API (optional): `https://<PUBLIC_HOST_OR_IP>/api/health` (if present) or other API routes
- Mongo Express via Nginx: `https://<PUBLIC_HOST_OR_IP>/mongo-express`
- Mongo Express direct: `http://<PUBLIC_HOST_OR_IP>:8081`

> For marking, include: terminal logs showing services up & DB connected; browser screenshots **with full HTTPS URL visible**; adding/updating data in **Mongo Express** and in the **Web app**, then verifying the change in both places.

## 6) How this maps to requirements
- **Four containers**: client, api, mongo, mongo-express (+ nginx proxy)  
- **Networks & ports**: all on `app-net`, exposed via Nginx 80/443; Mongo Express also on `8081`  
- **Volumes**: `mongo-data` persists DB  
- **Env vars**: Compose passes DB creds and client build-time API base  
- **HTTPS**: Nginx provides TLS for both the app and Mongo Express path

## 7) Troubleshooting
- Blank client calls to the API? Ensure `.env` has `REACT_APP_YOUR_HOSTNAME=https://<PUBLIC>/api` **before** building.
- API can't reach DB? Verify `ATLAS_URI` inside the `api` container points to `mongo:27017` with `authSource=admin`.
- Browser warns about cert? Expected for self-signed; proceed (or use a real cert).

---

**Tip for report:** Include the YAML & Dockerfiles with brief comments, note any tweaks you made, and match your screenshots to the marking checklist.
