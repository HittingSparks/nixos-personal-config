{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # Só o que é diferente neste host
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;

  boot.loader.systemd-boot.enable = true;
   boot.loader.efi.canTouchEfiVariables = true;
}
