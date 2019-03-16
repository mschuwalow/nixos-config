{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    custom.niv

    go
    zeal
    vscode
    unstable.meld    
    sublime3
    idea.idea-ultimate

    (python3.withPackages(ps: with ps; [ setuptools pip ]))
    
    nodejs-10_x
    unstable.postman
  ];
}
