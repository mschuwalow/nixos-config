{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    awscli
    cabal2nix
    # zeal
    vscode
    meld
    # custom.lorri
    # sublime3
    # unstable.sublime-merge
    nodePackages.node2nix
    git-heatmap
    (python3.withPackages (ps: with ps; [ ]))
    gnumake
    nixfmt
    nodejs-10_x
    postman
    sshfs
    ghq
    jq
    yq
    ngrok
    pspg
    watch
    wget
  ];
}
