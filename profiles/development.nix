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
in
{
  environment.systemPackages = with pkgs; [
    awscli2
    awslogs
    binutils-unwrapped
    cabal2nix
    circleci-cli
    ghq
    gnumake
    httpie
    httpstat
    jq
    k9s
    kubectl
    kubernetes-helm
    kubetail
    ngrok
    niv
    nixpkgs-fmt
    nixpkgs-review
    patchelf
    postman
    pspg
    python3Packages.aws2-wrap
    rnix-lsp
    sshfs
    sublime-merge
    vscode
    watch
    wget
    yq-go
    postgresql
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
