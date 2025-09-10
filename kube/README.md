# Kubernetes adaptation
_Scaling horizontally babay!!!_

This adapts the Docker Compose project (as defined at `/docker-compose.yml`) to be run as a horizontally-scalable application with Kubernetes.

<!-- TODO: Relevant: -->
> [!NOTE] Differences from the Compose equivalent
> All components of the Docker Compose project run at the same level, in a single Docker subnet. For this one, given Nginx scaling is practically of an incompatible architecture to Kube—we won't prioritise Nginx proxying immediately.
> Regardless, Kube services can get a decent bit done on their own.



