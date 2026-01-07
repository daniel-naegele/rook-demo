# Rook Demo
This is a demo repository for this [issue](https://github.com/rook/rook/issues/16841).

## About
The idea is to initialize an already running Linux host to a NixOS node using nixos-anywhere. In addition, k3s as a simple and lightweight Kubernetes distribution will be installed. Then Flux can be installed which reconciles all resources -- also the according Rook Ceph configurations. To ease this process, two setup scripts are provided in `hack`. Nix should be installed on the host executing shell script (your machine).

## Setup
First, add your public SSH keys to the `authorized_keys` file. Next, spin up a node, for example on Hetzner Cloud or the cloud provider of one's liking. The host must have a public IPv4 and IPv6 (not sure about IPv6 lol). As this is a demo, only the IPv4 will be used. 

### Configuration
Grab the IP addresses of your host and set the IPv4 in `nixos/k3s.nix`. In addition, set the IPv6 in `nixos/hetzner/demo.nix`.

### Bootstrap NixOS
Run
```sh
./hack/bootstrap.sh
```

### Bootstrap Flux
Wait for the node and k3s to be initialized and run the following.
```sh
./hack/bootstrap_flux.sh
```
This will initialize Flux. For your convenience the kubeconfig is copied to `k3s.yaml`

### Profit
Solve the [issue](https://github.com/rook/rook/issues/16841) and profit
