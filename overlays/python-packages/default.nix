pkgs: oldPkgs:
let
  packageOverrides = self: super: {
    jep = self.callPackage ./jep.nix { };
    opentracing = super.buildPythonPackage rec {
      pname = "opentracing";
      version = "2.2.0";
      doCheck = false;
      propagatedBuildInputs = [ self.future ];
      src = super.fetchPypi {
        inherit pname version;
        sha256 = "03kyzdqxzfs0qaz5fag4fspy9imh3s364zkqfz10pyaqbjx33lng";
      };
    };
    opentracing-utils = super.buildPythonPackage rec {
      pname = "opentracing-utils";
      version = "0.18.1";
      doCheck = false;
      propagatedBuildInputs = [ self.opentracing ];
      src = super.fetchPypi {
        inherit pname version;
        sha256 = "142zi9rfyhavw5874a1gnkjldlv578l5anffjzvwmc5ax0bhq2x7";
      };
    };
    scm-source = super.buildPythonPackage rec {
      pname = "scm-source";
      version = "1.0.11";
      doCheck = false;
      propagatedBuildInputs = [ self.clickclick self.pyyaml ];
      src = super.fetchPypi {
        inherit pname version;
        sha256 = "0dicplclkrzgkg5nkja5nin2r2919a404vkl81b6ccjg121pwxwm";
      };
    };
    stups = super.buildPythonPackage rec {
      pname = "stups";
      version = "1.1.21";
      doCheck = false;
      propagatedBuildInputs = [
        pkgs.awscli
        self.stups-kio
        self.stups-piu
        self.stups-senza
        self.stups-fullstop
        self.zalando-aws-cli
        self.zalando-kubectl
      ];
      src = super.fetchPypi {
        inherit pname version;
        sha256 = "1irdyy5jrv3d3ym6mhr848zanxkbazvw9b7qhlan5bg4vz7ns00c";
      };
    };
    stups-berry = super.buildPythonPackage rec {
      pname = "stups-berry";
      version = "1.0.28";
      doCheck = false;
      propagatedBuildInputs = [ self.dnspython self.pyyaml self.boto3 ];
      patches = [
        (oldPkgs.fetchpatch {
          name = "fix-pip10-compat.patch";
          url =
            "https://github.com/zalando-stups/berry/commit/209587e855d93cbe31339a88ab47f1cc641dba63.patch";
          sha256 = "0lgpz409c51d5xlw520szhb3fxrxss1kg7rdls8rwd2b95dfxp4j";
        })
      ];
      src = super.fetchPypi {
        inherit pname version;
        sha256 = "1qk15wligwzxfappajiby682np0ndvn0zvgq0b0lsn71adw82x2j";
      };
    };
    stups-cli-support = super.buildPythonPackage rec {
      pname = "stups-cli-support";
      version = "1.1.20";
      doCheck = false;
      propagatedBuildInputs = [ self.requests self.clickclick self.dnspython ];
      src = super.fetchPypi {
        inherit pname version;
        sha256 = "1nc5va3j9gc9w2vqmg9rbp91kw51xnmshkhifyhfvi7fcdd5r8rw";
      };
    };
    stups-fullstop = super.buildPythonPackage rec {
      pname = "stups-fullstop";
      version = "1.1.31";
      doCheck = false;
      propagatedBuildInputs =
        [ self.requests self.stups-cli-support self.stups-zign ];
      src = super.fetchPypi {
        inherit pname version;
        sha256 = "0cpsijwmciczn85kd3k8wmhaizh599wpa3swqkvlsrpa1a662212";
      };
    };
    stups-kio = super.buildPythonPackage rec {
      pname = "stups-kio";
      version = "0.1.22";
      doCheck = false;
      propagatedBuildInputs =
        [ self.requests self.stups-cli-support self.stups-zign ];
      src = super.fetchPypi {
        inherit pname version;
        sha256 = "14gfsj394b7f4yxl8li7kvgyilxvljbsln7zy5an8y1z8sl7dj0n";
      };
    };
    stups-pierone = super.buildPythonPackage rec {
      pname = "stups-pierone";
      version = "1.1.42";
      doCheck = false;
      propagatedBuildInputs =
        [ self.requests self.stups-cli-support self.stups-zign ];
      src = super.fetchPypi {
        inherit pname version;
        sha256 = "1bfwl31bmvhvfri52x1zjad8mlkhrnn5h24c69qgf0ahwasy3cn1";
      };
    };
    stups-piu = super.buildPythonPackage rec {
      pname = "stups-piu";
      version = "1.2.2";
      doCheck = false;
      propagatedBuildInputs =
        [ self.stups-zign self.pyperclip self.sshpubkeys self.boto3 ];
      src = super.fetchPypi {
        inherit pname version;
        sha256 = "14v4mpcr6wpclcarj1v8f1g0b4i02pp8axc1i4xasnb91145i4gh";
      };
    };
    stups-senza = super.buildPythonPackage rec {
      pname = "stups-senza";
      version = "2.1.138";
      doCheck = false;
      propagatedBuildInputs = [
        self.pytest
        self.boto3
        self.arrow
        self.dnspython
        self.pystache
        self.requests
        self.pyyaml
        self.typing
        self.raven
        self.stups-pierone
      ];
      src = super.fetchPypi {
        inherit pname version;
        sha256 = "0f1qlvrkkmwbhi578bcz9fv64kramag37jcbnp4d90kwfr2cca2v";
      };
    };
    stups-tokens = super.buildPythonPackage rec {
      pname = "stups-tokens";
      version = "1.1.19";
      doCheck = false;
      propagatedBuildInputs = [ self.requests ];
      src = super.fetchPypi {
        inherit pname version;
        sha256 = "0q1ir951lcmx9wdcj328x5y165x9rkpzr3v06jbjmmdzrj1ssc3q";
      };
    };
    stups-zign = super.buildPythonPackage rec {
      pname = "stups-zign";
      version = "1.2";
      doCheck = false;
      propagatedBuildInputs = [ self.stups-tokens self.stups-cli-support ];
      src = super.fetchPypi {
        inherit pname version;
        sha256 = "06dga2144xp715lbjgmvq04a3i9hka0p232skpnx2f72pjgb6ral";
      };
    };
    zalando-aws-cli = super.buildPythonPackage rec {
      pname = "zalando-aws-cli";
      version = "1.2.5.25";
      doCheck = false;
      propagatedBuildInputs = [
        self.boto3
        self.requests
        self.pyjwt
        self.pyyaml
        self.clickclick
        self.stups-zign
      ];
      src = super.fetchPypi {
        inherit pname version;
        sha256 = "0yv7s9i5ydiaq60m12qq9dk2v24ilpkpad44drhz35ggsrldhqhf";
      };
    };
    zalando-kubectl = super.buildPythonPackage rec {
      pname = "zalando-kubectl";
      version = "1.17.5.114";
      doCheck = false;
      propagatedBuildInputs = [
        self.stups-piu
        self.stups-cli-support
        self.zalando-aws-cli
        self.natsort
        self.humanize
      ];
      src = super.fetchPypi {
        inherit pname version;
        sha256 = "0hichmlil3i5mgnaaj45gfcwswkq62ccglkbpks0gkb5x0r1k0rd";
      };
    };
    zmon-cli = super.buildPythonPackage rec {
      pname = "zmon-cli";
      version = "1.1.62";
      doCheck = false;
      propagatedBuildInputs = [
        self.clickclick
        self.pyyaml
        self.requests
        self.stups-zign
        self.opentracing-utils
        self.easydict
        self.setuptools
      ];
      src = super.fetchPypi {
        inherit pname version;
        sha256 = "1lmap3zyl2jlynnlk8h513bzfvq890b07bimndpimj46varlixxm";
      };
    };
  };
in {
  python = oldPkgs.python.override { inherit packageOverrides; };
  python3 = oldPkgs.python3.override { inherit packageOverrides; };
  python36 = oldPkgs.python36.override { inherit packageOverrides; };
  python37 = oldPkgs.python37.override { inherit packageOverrides; };
  python38 = oldPkgs.python38.override { inherit packageOverrides; };
  python39 = oldPkgs.python39.override { inherit packageOverrides; };
  python310 = oldPkgs.python310.override { inherit packageOverrides; };
}
