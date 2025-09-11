# Kubernetes adaptation
_Scaling horizontally babay!!!_

This adapts the Docker Compose project (as defined at `/docker-compose.yml`) to be run as a horizontally-scalable application with Kubernetes.

## Architecture
> [!NOTE]
> ### Differences from the Compose equivalent
> All components of the Docker Compose project run at the same level, in a single Docker subnet. For this one, given Nginx scaling is practically of an incompatible architecture to Kube—we won't prioritise Nginx proxying immediately.
> Regardless, Kube services can get a decent bit done on their own.

The basic transformation from Docker Compose → Kube converts the "Docker Services" to Kubernetes deployments. We have the following deployments:
* **`api`:** DB API accessed by `client` (the web app) to interface with `mongo` which in turn uses the DB. This is the world-facing DB API, where `mongo` is hidden inside the cluster and is inaccessible to outsiders
* **`client`:** This serves the web page and processes form inputs to facilidate CRUD operations, it uses the `api` endpoint to interface with the database over the internet (for example)
* **`me` (Mongo Express):** Administration web UI for the internal MongoDB server. This is also world-facing, facilitating admin users to manage the database from the outside
* **`mongo`:** Runs the DB and is exposed to the cluster as an accessible service, but its ports are never forwarded to the world

Each of the above has a Kubernetes _Service_ which opens specific ports from within pods to the "default cluster subnet," assigning a local domain based on the service ID. e.g. `services/mongo.yml` lists `.metadata.name` as `"mongo-service"` (and specific ports to open), where therefore other deployments can access `http://mongo-service/` and it will resolve to a node IP of the pod(s) running the `mongo-deployment` container(s).

`api`, `client`, and `me` are all exposed (and later port forwarded if you wish to not set up a reverse proxy layer) to the internet by forwarding their ports using `kubectl port-forward` ([see below](#Scaled%20(K8s))). `mongo`'s service exposes the pod port 27017 to the cluster subnet port 27017, so that other deployments can request `http://mongo-service/`—but the cluster port 27017 is **not** exposed to the local machine (and is thus inaccessible).

## Requirements
To run this, you'll need these packages: (or their equivalents on other distros)
* `docker` (`containerd` and `runc` as dependencies if not automatically added)
* `minikube`, and either:
	* `alias kubectl="minikube kubectl --"` for every terminal you use to work on this
	* `kubectl` package itself
* `docker-compose`
	* (Optional:) `docker-buildx` for faster/more reliable building

Additionally, if you want to manage Docker stuff as non-root, add yourself to the `docker` group if not already:
```sh
if [ $(groups | grep -P '( |^)docker( |$)' | wc -l) = 0 ]; then
	if [ $(cat /etc/group | grep '^docker:.*:.*:.*$' | wc -l) = 0]; then
		echo ADDING docker GROUP
		echo IF YOU WANT TO REMOVE IT LATER, RUN: sudo groupdel docker
		sudo groupadd docker
	fi

	sudo usermod -aG docker $USER
fi
```
Then you'll need to re-login or launch a fresh terminal specifically with `newgrp docker` to be able to user Docker normally.

## Bringing up and down
### Before first run (K8s-speficic)
#### Set up Minikube
```sh
minikube start
minikube status
```

#### Set up `.env`
**Note that the K8s doesn't quite support a `.env` file like JS or Docker does!** We will need to use the `/.env` file at the root of this project and convert it to a YAML file for use with dependent deployment and service definition schemas.

**We will assume the environment variables are kept in a ConfigMap called `env.yml`**, in `/kube/`.

```sh
# From _inside_ /kube/:
kubectl delete configmap env
kubectl create configmap env --from-env-file=../.env # This will automatically store the values as an internal k:v storage ConfigMap for subsequent `apply`s
```

### Useful maintenance utilities
```sh
kubectl get pods [-A]
kubectl describe pod <id>
kubectl logs <pod>
# Or logs by deployment name:
kubectl logs $(kubectl get pods | grep "<app>-deployment" | awk '{print $1}')
kubectl get deployments
kubectl get services # Shows internal/cluster subnet ports too!
# Open terminal by deployment:
kubectl exec --stdin --tty $(kubectl get pods | grep "<app>-deployment" | awk '{print $1}') -- /bin/sh

docker logs <image>
docker images
docker container ls [| grep -v "k8s"]

# Pick from any of the following to open the domain `<foo>-service` to your local machine instead of cluster-internal-only:
# If you follow what's in the § Bringing up (K8s) section, then the only two non-open-to-the-world services are `kubernetes` and `mongo-service`
kubectl port-forward svc/<foo>-service 27017:27017 --address 0.0.0.0 >/dev/null 2>&1 & disown

# Get all pods' env vars: (Works if they're crashed/errored too I think)
kubectl set env pods --all --list
```

### Bringing up
#### Non-scaled (Docker Compose)
```sh
# Set working dir to root (where `docker-compose.yml` is)
sudo docker compose build # Only if you've changed Dockerfiles etc

sudo docker compose up [-d]
```

#### Scaled (K8s)
The Docker Compose project provides 2 `mern-app-stack-*` images, which are local and thus must be built with `docker compose build` (see [§ Bringing up (Docker Compose)](#Non-scaled%20(Docker%20Compose)). **As such, you must re-`build` the Compose project** (without actually needing/having to use/run it) ***every time*** you want to relaunch the cluster—_specifically for the cases where you changed the underlying application_.<br>
If you just changed the service(s)/deployment(s), then it doesn't really matter.

```sh
# Go into /kube/: These will both override old ones, so no need to remove :)
kubectl apply -f services/ # Need to set up services first for DNS to resolve when deployments launch
kubectl apply -f deployments/

# To emulate the Docker Compose Nginx setup, we will first need to expose the desired ports for the bare minimum access:
kubectl port-forward svc/client-service 3000:3000 --address 0.0.0.0 >/dev/null 2>&1 & disown
kubectl port-forward svc/me-service     8081:8081 --address 0.0.0.0 >/dev/null 2>&1 & disown
kubectl port-forward svc/api-service    5000:5000 --address 0.0.0.0 >/dev/null 2>&1 & disown
# (Substitute /dev/null with a text file if there are errors when trying to forward ports)
```

### Bringing down
#### Non-scaled (Docker)
```sh
sudo docker compose down
```

#### Scaled (K8s)
```sh
kubectl delete --all services
kubectl delete --all deployments
```

### After last run
```sh
docker system prune -a --volumes
docker rm -vf $(docker ps -aq)
docker rmi -f $(docker images -aq)

minikube delete
rm -rf ~/.minikube/
```

