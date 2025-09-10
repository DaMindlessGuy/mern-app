# Kubernetes adaptation
_Scaling horizontally babay!!!_

This adapts the Docker Compose project (as defined at `/docker-compose.yml`) to be run as a horizontally-scalable application with Kubernetes.

<!-- TODO: Relevant: -->
> [!NOTE] Differences from the Compose equivalent
> All components of the Docker Compose project run at the same level, in a single Docker subnet. For this one, given Nginx scaling is practically of an incompatible architecture to Kube—we won't prioritise Nginx proxying immediately.
> Regardless, Kube services can get a decent bit done on their own.

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
kubectl get deployments
kubectl get services # Shows internal/cluster subnet ports too!

docker logs <image>
docker images
docker container ls [| grep -v "k8s"]
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

```
# Go into /kube/: These will both override old ones, so no need to remove :)
kubectl apply -f deployments/
kubectl apply -f services/
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

