{ pkgs, usuario, ... }:
{
  # Localização pt_BR
  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "pt_BR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT    = "pt_BR.UTF-8";
    LC_MONETARY       = "pt_BR.UTF-8";
    LC_NAME           = "pt_BR.UTF-8";
    LC_NUMERIC        = "pt_BR.UTF-8";
    LC_PAPER          = "pt_BR.UTF-8";
    LC_TELEPHONE      = "pt_BR.UTF-8";
    LC_TIME           = "pt_BR.UTF-8";
  };

  # Teclado ABNT2
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };
  console.keyMap = "br-abnt2";

  # KDE Plasma 6
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # to meio sem memoria guys
   zramSwap = {
   enable = true;
   memoryPercent = 200; # Altere para a porcentagem desejada (ex: 25, 50, 100)
   algorithm = "zstd"; # Algoritmo de compressão (zstd, lz4, etc.)
   priority = 5;       # Prioridade do swap
   };


  # Pacotes de SISTEMA (disponíveis para todos os usuários, inclusive root)
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    htop
    btop
    jdk
    fastfetch
    google-chrome
    firefox
    zapzap
    localsend
    pciutils
    android-tools
    appimage-run
    kdePackages.kpmcore
    kdePackages.isoimagewriter
    kdePackages.qtwebsockets
    (python3.withPackages (ps: [ ps.websockets ]))
  ];

  users.users.${usuario} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.flatpak.enable = true;

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";   
    openFirewall = true;            
  };

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  networking.networkmanager.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05"; # mantenha o valor da sua instalação original
}
