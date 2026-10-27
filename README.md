Simple nixos/plasma config I made with a lot of help from Claude (I didn't want to waste a week of my life configuring this, sorgy)

In modules/common.nix exist the system files and packages I use
In the hosts/{something}/default.nix exist the different hardware/machine specific stuff
in home/default.nix exists the home manager config, alongside plasma.nix, which contains plasma specific stuff

If you wanna use this (for some reason):
1. change username in flake.nix
2. adjust hardware-configuration.nix accordingly
3. when doing 'sudo nixos-rebuild switch --flake .#[machine]', adjust [machine accordingly, with "desktop" being more complete and "batata" having less packages, for devices such as potato pcs and chromebooks

uhh yeah I guess thats it for now
