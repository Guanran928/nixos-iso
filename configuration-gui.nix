{ pkgs, ... }:
{
  fonts = {
    # 默认 CJK 字体为 GNU Unifont
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];

    fontconfig.defaultFonts = {
      sansSerif = [
        "Noto Sans"
        "Noto Sans CJK SC"
      ];
      serif = [
        "Noto Serif"
        "Noto Serif CJK SC"
      ];
      monospace = [
        "Noto Sans Mono"
        "Noto Sans Mono CJK SC"
      ];
    };
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
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

      settings.addons.pinyin = {
        # Removes cloudpinyin notification
        globalSection.FirstRun = "False";
      };
    };
  };

  programs.clash-verge = {
    enable = true;
    tunMode = true; 
  };

  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };
}
