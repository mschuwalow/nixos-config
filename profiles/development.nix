{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    custom.niv

    go
    zeal
    emacs
    vscode
    unstable.meld
    custom.lorri
    sublime3
    idea.idea-ultimate

    (python3.withPackages(ps: with ps; [ virtualenv ]))
    
    nodejs-10_x
    unstable.postman
    sshfs
  ];
}
