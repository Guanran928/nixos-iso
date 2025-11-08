{
  nix.settings = {
    # TUNA - 清华大学 Mirror
    substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];

    # 启用 Flakes
    experimental-features = [
      "flakes"
      "nix-command"
    ];
  };
}
