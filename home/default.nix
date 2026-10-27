{ pkgs, lib, usuario, hostname, ... }:
{
  imports = [ ./plasma.nix ];

  home.username = usuario;
  home.homeDirectory = "/home/${usuario}";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    # Tiling no KWin
    kdePackages.krohnkite

    # Tema Catppuccin Mocha Mauve para o KDE
    (catppuccin-kde.override {
      flavour = [ "mocha" ];
      accents = [ "mauve" ];
    })
    kando
    prismlauncher
    hyfetch
    tailscale
    cava
    kdePackages.krfb
    kdePackages.krdc
    kdePackages.ktorrent
    kdePackages.kamoso
    kdePackages.kcalc
    kdePackages.kwrited
    mpv
  ] ++ lib.optionals (hostname == "desktop") [
    vesktop
    samloader-rs
    distrobox
    podman
    lact
    gnome-boxes
    proton-vpn
    tetrio-desktop
    inkscape
    obsidian
    vlc
    distroshelf
    drawy
  ];


  # Catppuccin só no cava (flavor/accent valem para todas as portas ativadas)
  catppuccin.flavor = "mocha";
  catppuccin.accent = "mauve";

  programs.cava.enable = true;
  catppuccin.cava.enable = true;

  programs.home-manager.enable = true;
}
