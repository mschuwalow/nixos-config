{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [    
    zeal
    vscode
    meld    
    sublime3
    idea.idea-ultimate

    (python3.withPackages(ps: with ps; [ setuptools pip ]))
    
    nodejs-10_x
    unstable.postman
  ];
}
