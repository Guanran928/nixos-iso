{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
    in
    {
      packages.x86_64-linux =
        builtins.mapAttrs (_n: v: v.config.system.build.isoImage) self.nixosConfigurations
        // {
          default = self.nixosConfigurations.minimal.config.system.build.isoImage;
        };

      # qemu-system-x86_64 -enable-kvm -m 8192 -smp 16 -cdrom result/iso/nixos-*.iso
      devShells.x86_64-linux.default = pkgs.mkShellNoCC {
        packages = with pkgs; [ qemu ];
      };

      nixosConfigurations = {
        minimal = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-base.nix")
            ./configuration.nix
          ];
        };

        gnome = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix")
            ./configuration.nix
            ./configuration-gui.nix

            (
              { pkgs, ... }:
              {
                i18n.inputMethod.fcitx5 = {
                  waylandFrontend = true;
                };

                environment.systemPackages = with pkgs; [
                  # for fcitx5 tray & popup
                  gnomeExtensions.appindicator
                  gnomeExtensions.kimpanel
                ];

                programs.dconf = {
                  enable = true;
                  profiles.user.databases = [
                    {
                      settings."org/gnome/shell" = {
                        enabled-extensions = with pkgs.gnomeExtensions; [
                          appindicator.extensionUuid
                          kimpanel.extensionUuid
                        ];
                      };
                    }
                  ];
                };
              }
            )
          ];
        };

        plasma6 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix")
            ./configuration.nix
            ./configuration-gui.nix
          ];
        };
      };
    };
}
