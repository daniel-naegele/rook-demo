{
  lib,
  ...
}:
let
  address = "157.180.79.44";
in
{

  services.k3s = {
    enable = true;
    token = "asdf";
    extraFlags = [
      "--tls-san=${address}"
      "--disable=local-storage"
      "--write-kubeconfig-group=nixos"
      "--write-kubeconfig-mode=0640"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 6443 ];

  systemd.services.containerd.serviceConfig = {
    LimitNOFILE = lib.mkForce null;
  };
}
