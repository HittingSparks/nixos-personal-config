{ config, pkgs, ... }:
let
  # ID do Kurve, deduzido do caminho do seu erro anterior (veja a nota 2)
  kurveId = "luisbocanegra.audio.visualizer";

  # Espaçador que se expande e empurra os vizinhos para os lados
  expandingSpacer = {
    name = "org.kde.plasma.panelspacer";
    config.General.expanding = true;
  };
in
{
  home.packages = with pkgs; [
    kurve
    plasmusic-toolbar
  ];

  # Script próprio: Meta+Q fecha a janela sob o ponteiro, sem mexer no foco
  xdg.dataFile."kwin/scripts/closeunderpointer/metadata.json".text = ''
    {
      "KPlugin": {
        "Id": "closeunderpointer",
        "Name": "Close Window Under Pointer",
        "Description": "Meta+Q fecha a janela que está sob o mouse",
        "Authors": [{ "Name": "local" }],
        "License": "MIT",
        "Version": "1.0"
      },
      "KPackageStructure": "KWin/Script",
      "X-Plasma-API": "javascript",
      "X-Plasma-MainScript": "code/main.js"
    }
  '';

  xdg.dataFile."kwin/scripts/closeunderpointer/contents/code/main.js".text = ''
    registerShortcut(
      "Close Window Under Pointer",
      "Close Window Under Pointer",
      "Meta+Q",
      function () {
        var pos = workspace.cursorPos;
        var wins = workspace.stackingOrder; // de baixo para cima
        for (var i = wins.length - 1; i >= 0; i--) {
          var w = wins[i];
          if (!w.closeable || w.minimized) continue;
          if (!(w.normalWindow || w.dialog)) continue;
          if (!w.onAllDesktops && w.desktops.indexOf(workspace.currentDesktop) === -1) continue;
          var g = w.frameGeometry;
          if (pos.x >= g.x && pos.x < g.x + g.width &&
              pos.y >= g.y && pos.y < g.y + g.height) {
            w.closeWindow();
            return;
          }
        }
      }
    );
  '';

  programs.plasma = {
    enable = true;

    workspace = {
      lookAndFeel = "Catppuccin-Mocha-Mauve";
      colorScheme = "CatppuccinMochaMauve";
      wallpaper = "${config.home.homeDirectory}/Imagens/Wallpapers/oneshot.png";
    };

    shortcuts = {
      kwin."Close Window Under Pointer" = "Meta+Q";
      plasmashell."manage activities" = [ ];
    };

    configFile = {
      "kwinrc"."Plugins"."krohnkiteEnabled" = false;
      "kwinrc"."Plugins"."closeunderpointerEnabled" = true;

      "kwinrc"."MouseBindings"."CommandActiveTitlebar2" = "Close";
      "kwinrc"."MouseBindings"."CommandInactiveTitlebar2" = "Close";

      "kwinrc"."Wayland"."EnablePrimarySelection" = false;
      "klipperrc"."General"."IgnoreSelection" = true;

      "kwinrc"."Desktops"."Number" = 4;
      "kwinrc"."Desktops"."Rows" = 1;
    };

    panels = [
      # Barra superior
      {
        location = "top";
        height = 40;
        widgets = [
          "org.kde.plasma.kickoff"          # 1. iniciador
          "org.kde.plasma.pager"            # 2. áreas de trabalho
          "plasmusic-toolbar"               # 3. player de música
          expandingSpacer
          "org.kde.plasma.digitalclock"     # 4. relógio (centro)
          kurveId                           # 5. Kurve, ao lado do relógio
          expandingSpacer
          "org.kde.plasma.systemtray"       # 6. bandeja
          "org.kde.plasma.showdesktop"      # 7. espiar o desktop (canto)
        ];
      }

      # Dock inferior: flutuante, centralizado, esconde sozinho
      {
        location = "bottom";
        height = 40;
        floating = true;
        hiding = "autohide";
        alignment = "center";
        lengthMode = "fit";
        widgets = [
          {
            iconTasks.launchers = [
              "applications:org.kde.dolphin.desktop"
              "applications:org.kde.konsole.desktop"
              "applications:firefox.desktop"
              "applications:google-chrome.desktop"
            ];
          }
        ];
      }
    ];
  };
}
