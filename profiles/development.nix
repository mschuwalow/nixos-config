{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    cabal-install
    cabal2nix
    stack
    # go
    # zeal
    # emacs
    vscode
    unstable.meld
    # custom.lorri
    # sublime3
    # unstable.sublime-merge
    idea.idea-ultimate
    nodePackages.node2nix
    custom.git-heatmap
    ncurses.dev
    (python3.withPackages(ps: with ps; [ virtualenv ]))
    
    nodejs-10_x
    unstable.postman
    sshfs
  ];
}
