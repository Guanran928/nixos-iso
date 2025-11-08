{
  pkgs,
  ...
}:
{
  # 默认压缩参数太慢
  # https://nixos.wiki/wiki/Creating_a_NixOS_live_CD#Building_faster
  isoImage = {
    squashfsCompression = "gzip -Xcompression-level 1";
  };

  boot.loader.grub.memtest86.enable = true;

  console = {
    earlySetup = true;
    keyMap = "dvorak";
  };

  environment.systemPackages = with pkgs; [
    gparted
    kdiskmark
  ];

  programs = {
    firefox.enable = true;
    fish.enable = true;
    sway.enable = true;
    tmux.enable = true;

    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
  };

  users.users.nixos.shell = pkgs.fish;

  environment.etc."sway/config.d/live.conf".text = ''
    exec fcitx5 -d

    input type:keyboard {
      xkb_variant dvorak
      xkb_options caps:escape,altwin:swap_lalt_lwin
    }
  '';

  nix.settings = {
    # TUNA - 清华大学 Mirror
    substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];

    # 启用 Flakes
    experimental-features = [
      "flakes"
      "nix-command"
    ];
  };

  # GParted 依赖 Polkit 提权
  # 使 Polkit 不向 wheel 组用户询问密码，否则会因为没有 agent 导致验证失败
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel"))
        return polkit.Result.YES;
    });
  '';

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = [ pkgs.qt6Packages.fcitx5-chinese-addons ];

      # 默认启用拼音
      settings.inputMethod = {
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "pinyin";
        };
        "Groups/0/Items/0" = {
          Name = "keyboard-us";
          Layout = "";
        };
        "Groups/0/Items/1" = {
          Name = "pinyin";
          Layout = "";
        };
        GroupOrder = {
          "0" = "Default";
        };
      };
    };
  };
}
