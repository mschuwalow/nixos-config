{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    go
    zeal
    emacs
    vscode
    unstable.meld
    custom.lorri
    sublime3
    unstable.sublime-merge
    idea.idea-ultimate
    nodePackages.node2nix
    custom.git-heatmap

    (python3.withPackages(ps: with ps; [ virtualenv ]))
    
    nodejs-10_x
    unstable.postman
    sshfs
  ];
}
