{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }@inputs:
    {
      # 使 `nix build` 命令直接构建镜像，免去输入参数
      packages."x86_64-linux".default = self.nixosConfigurations.live.config.system.build.isoImage;

      nixosConfigurations.live = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs.inputs = inputs;
        modules = [
          (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-base.nix")
          ./configuration.nix
        ];
      };
    };
}
