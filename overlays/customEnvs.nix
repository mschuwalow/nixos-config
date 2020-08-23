pkgs: oldPkgs: {
  myPython = pkgs.python36.withPackages (ps:
    with ps; [
      pyyaml
      click
      boto3
      requests
      clickclick
      scm-source
      stups
      stups-senza
      zalando-aws-cli
      zalando-kubectl
      zmon-cli
    ]);
  myR = pkgs.rWrapper.override { packages = with oldPkgs.rPackages; [ ]; };
}
