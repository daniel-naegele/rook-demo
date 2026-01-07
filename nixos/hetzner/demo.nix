# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./disk-config.nix
    ./hardware-configuration.nix
    ../configuration.nix
    ../k3s.nix
  ];

  networking = {
    hostId = "c4c9a7e5";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp1s0";
    };
    interfaces.enp1s0 = {
      ipv6.addresses = [
        {
          address = "2a01:4f9:c012:5a09::1";
          prefixLength = 64;
        }
      ];
    };
  };

  system.stateVersion = "25.11";
}
