{ pkgs, ... }:
let
  vscode' = pkgs.vscode-with-extensions.override {
    vscodeExtensions = (with pkgs.vscode-extensions;
      [
        aaron-bond.better-comments
        alefragnani.project-manager
        arrterian.nix-env-selector
        bbenoist.Nix
        brettm12345.nixfmt-vscode
        christian-kohler.path-intellisense
        codezombiech.gitignore
        coenraads.bracket-pair-colorizer
        equinusocio.vsc-community-material-theme
        equinusocio.vsc-material-theme-icons
        formulahendry.auto-close-tag
        formulahendry.auto-rename-tag
        gruntfuggly.todo-tree
        ms-azuretools.vscode-docker
        sleistner.vscode-fileutils
        vscodevim.vim
        pkgs.unstable.vscode-extensions.ms-vsliveshare.vsliveshare
      ] ++ sets.scala ++ sets.haskell ++ sets.python ++ sets.rust);
  };
in {
  environment.systemPackages = with pkgs; [
    awscli
    cabal2nix
    vscode
    kubetail
    kubectl
    kubernetes-helm
    sublime-merge
    (python3.withPackages
      (ps: with ps; [ numpy pandas pendulum pillow jupyterlab pylint ]))
    gnumake
    niv
    nixfmt
    httpstat
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
    binutils-unwrapped
    nixpkgs-review
    patchelf
    rnix-lsp
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
