{
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.kernelParams = [
    "ip=dhcp"
    "nvme_core.multipath=Y"
  ];
  boot.kernelModules = [
    "rbd"
    "nbd"
    "ceph"
    "e1000e"
    "nft-expr-counter"
  ];
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
    "vm.nr_hugepages" = 1024;
    "net.ipv4.ip_forward" = 1;
  };

  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
  };

  networking.enableIPv6 = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      6443
      22
      80
      443
    ];
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    btop
    cachix
    git
    htop
    lvm2
    iproute2
    openssh
    vim
    wget
  ];

  security.sudo.wheelNeedsPassword = false;
  users.users.k8s = {
    isSystemUser = true;
    group = "k8s";
  };

  users.users.nixos = {
    shell = pkgs.zsh;
    isNormalUser = true;
    group = "nixos";
    extraGroups = [
      "wheel"
      "sudo"
    ];
    openssh.authorizedKeys.keyFiles = [ ../authorized_keys ];
  };
  nix.settings.trusted-users = [ "nixos" ];

  users.groups.k8s = { };
  users.groups.nixos = { };

  services.openssh = {

    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };
}
