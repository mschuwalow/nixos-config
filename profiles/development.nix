{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    awscli
    cabal2nix
    unstable.vscode
    meld
    kubetail
    kubectl
    kubernetes-helm
    unstable.sublime-merge
    nodePackages.node2nix
    git-heatmap
    (python3.withPackages (ps: with ps; [
      numpy
      pandas
      pendulum
      pillow
      jupyterlab
      pylint
    ]))
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
    httpie
  ];

  # disable sublime asking for license
  networking.hosts = {
    "127.0.0.1" = [ "www.sublimetext.com" "sublimetext.com" ];
  };

  services.vsliveshare.enable = true;
}
