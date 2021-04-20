{ config, pkgs, lib, ... }:

{
  home-manager = {
    users.root = {

      home.sessionVariables = {
        EDITOR = "${pkgs.micro}/bin/micro";
        VISUAL = "${pkgs.micro}/bin/micro";
        PAGER = "${pkgs.less}/bin/less";
      };

      programs = {
        git = {
          package = pkgs.gitAndTools.gitFull;
          enable = true;
          extraConfig = { pull = { ff = "only"; }; };
          userName = "Maxim Schuwalow";
          userEmail = "maxim.schuwalow@gmail.com";
        };
        ssh = {
          enable = true;
          matchBlocks = {
            "github.com" = {
              hostname = "github.com";
              user = "git";
              identityFile = "/run/secrets/github_rsa";
            };
          };
        };
      };

      qt = {
        enable = true;
        platformTheme = "gtk";
      };
    };
  };

  users.users.root = {
    passwordFile = "/run/secrets/pw-root";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDC2WQH2OAYBUg4R0+6lqyrTpuQAbYom1aouAWvcE1uGZbppyvxFQNHULdVz+rO7Q1xbP+NiLwljiJC3HDJyvrTmPfmYeKW+3j5+xeFAQZ8PayJr0N6qy7UY0NiOmfgHgQQOiU9mYl443rL4nthb6BhV66idaMqBhrklDSvjWZhobgOl7CO1BtnTeFG+6mrjgj+zvhgw58uX+w84RY8mS0QowS2yDl9q5TM2yZrBOLQFz/tLKSHei64Ch4C1AVCkLTvSug7ul9Go7dTiLYD2ddyjauo+/HVUl8Y9CiBC20HP+nnEvEbYF1L8b3uLDMpnvdeGIxpdcUyV1Ax9f2t1zHd schuwalow_rsa"
    ];
  };
}
