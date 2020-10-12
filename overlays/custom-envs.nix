self: super: {
  myPython = super.python36.withPackages (ps:
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
  myR = super.rWrapper.override { packages = with super.rPackages; [ ]; };
}
