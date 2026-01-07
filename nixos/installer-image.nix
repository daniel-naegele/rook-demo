{
  system.activatable = false;
  networking.hostName = "nixos-install";
  users.users.root.openssh.authorizedKeys.keyFiles = [ ../authorized_keys ];
}
