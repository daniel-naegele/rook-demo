{
  pkgs ? import <nixpkgs> { },
  ...
}:
with pkgs;
mkShell {
  packages = [
    flux
    kubectl
    kubectx
    kubernetes-helm
    kube-capacity
    kubectl-view-secret
  ];

  shellHook = ''

  '';
}
