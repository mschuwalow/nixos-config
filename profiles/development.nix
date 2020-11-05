{ pkgs, ... }:
let
  vscode' = pkgs.vscode-with-extensions.override {
    vscodeExtensions = (with pkgs.vscode-extensions;
      [
        aaron-bond.better-comments
        alefragnani.project-manager
        arrterian.nix-env-selector
        bbenoist.Nix
        christian-kohler.path-intellisense
        codezombiech.gitignore
        coenraads.bracket-pair-colorizer
        equinusocio.vsc-community-material-theme
        equinusocio.vsc-material-theme-icons
        formulahendry.auto-close-tag
        formulahendry.auto-rename-tag
        gruntfuggly.todo-tree
        llvm-org.lldb-vscode
        matklad.rust-analyzer
        ms-azuretools.vscode-docker
        ms-python.vscode-pylance
        sleistner.vscode-fileutils
        wmaurer.vscode-jumpy
        vscodevim.vim
      ] ++ sets.scala ++ sets.haskell);
  };
in {
  environment.systemPackages = with pkgs; [
    awscli
    cabal2nix
    direnv
    vscode'
    kubetail
    kubectl
    kubernetes-helm
    sublime-merge
    git-heatmap
    (python3.withPackages
      (ps: with ps; [ numpy pandas pendulum pillow jupyterlab pylint ]))
    gnumake
    niv
    nixfmt
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

  services = {
    lorri.enable = true;
    # vsliveshare.enable = true;
  };
}
