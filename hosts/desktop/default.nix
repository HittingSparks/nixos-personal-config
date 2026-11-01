{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # Só o que é diferente neste host
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    };
   hardware.nvidia = {
    modesetting.enable = true;
    open = true;            # veja a nota abaixo
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.new_feature;
    };

  services.switcherooControl.enable = true;

  virtualisation.docker.enable = true;
  environment.sessionVariables.DBX_CONTAINER_MANAGER = "docker";
  hardware.nvidia-container-toolkit.enable = true;


  boot.loader.systemd-boot.enable = true;
   boot.loader.efi.canTouchEfiVariables = true;
}
