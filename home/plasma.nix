{ config, pkgs, lib, ... }:
{
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
      # Meta+Q é, por padrão, o seletor de atividades; libera a tecla
      plasmashell."manage activities" = [ ];
    };

    configFile = {
      # Krohnkite desligado (conflita com o HyprKwin)
      "kwinrc"."Plugins"."krohnkiteEnabled" = false;
      "kwinrc"."Plugins"."closeunderpointerEnabled" = true;

      # Clique do meio na barra de título fecha a janela
      "kwinrc"."MouseBindings"."CommandActiveTitlebar2" = "Close";
      "kwinrc"."MouseBindings"."CommandInactiveTitlebar2" = "Close";

      # Desativa a colagem com o botão do meio (seleção primária)
      "kwinrc"."Wayland"."EnablePrimarySelection" = false;
      "klipperrc"."General"."IgnoreSelection" = true;

      "kwinrc"."Desktops"."Number" = 4;
      "kwinrc"."Desktops"."Rows" = 1;
    };

    panels = [
      {
        location = "top";
        height = 40;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];
  };
}
