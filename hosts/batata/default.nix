{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

   boot.loader.systemd-boot.enable = true;
   boot.loader.efi.canTouchEfiVariables = true;
}
