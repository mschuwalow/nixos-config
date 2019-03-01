{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    zeal
    vscode
    meld    
    sublime3
    idea.idea-ultimate

    python3Full
    python3Packages.pip

    ripgrep
    unstable.postman
  ];
}
