self: super:
let
  mp = extension:
    super.vscode-utils.buildVscodeMarketplaceExtension {
      mktplcRef = extension;
      meta = { license = super.lib.licenses.mit; };
    };
in rec {
  vscode-extensions = super.lib.recursiveUpdate super.vscode-extensions {
    alanz.vscode-hie-server = mp {
      name = "vscode-hie-server";
      publisher = "alanz";
      version = "0.2.1";
      sha256 = "1ql3ynar7fm1dhsf6kb44bw5d9pi1d8p9fmjv5p96iz8x7n3w47x";
    };
    alefragnani.project-manager = mp {
      name = "project-manager";
      publisher = "alefragnani";
      version = "10.12.0";
      sha256 = "0i8rx8gcrppshgz97d6p9widfnwwwzq7g5hgkrz1g5cg2fl34ic3";
    };
    formulahendry.auto-rename-tag = mp {
      name = "auto-rename-tag";
      publisher = "formulahendry";
      version = "0.1.5";
      sha256 = "1ic3nxpcan8wwwzwm099plkn7fdy0zz2575rh4znc4sqgcqywh2i";
    };
    aaron-bond.better-comments = mp {
      name = "better-comments";
      publisher = "aaron-bond";
      version = "2.1.0";
      sha256 = "0kmmk6bpsdrvbb7dqf0d3annpg41n9g6ljzc1dh0akjzpbchdcwp";
    };
    codezombiech.gitignore = mp {
      name = "gitignore";
      publisher = "codezombiech";
      version = "0.6.0";
      sha256 = "0gnc0691pwkd9s8ldqabmpfvj0236rw7bxvkf0bvmww32kv1ia0b";
    };
    coenraads.bracket-pair-colorizer = mp {
      name = "bracket-pair-colorizer";
      publisher = "coenraads";
      version = "1.0.61";
      sha256 = "0r3bfp8kvhf9zpbiil7acx7zain26grk133f0r0syxqgml12i652";
    };
    equinusocio = {
      vsc-material-theme = mp {
        name = "vsc-material-theme";
        publisher = "equinusocio";
        version = "33.0.0";
        sha256 = "1r8g9jm34xp7lld9mwv3sja1913aan0khxqrp7az89szwpnv73vg";
      };
      vsc-community-material-theme = mp {
        name = "vsc-community-material-theme";
        publisher = "equinusocio";
        version = "1.4.2";
        sha256 = "1xll3dqicsssjw0b8was7jw43n1mdrlx5vcl15hq1va19rwyj28n";
      };
      vsc-material-theme-icons = mp {
        name = "vsc-material-theme-icons";
        publisher = "equinusocio";
        version = "1.2.0";
        sha256 = "0wh295ncm8cbxmw9i3pvg703sn1gw7vp3slbklwjxskb4zivvfk4";
      };
    };
    sleistner.vscode-fileutils = mp {
      name = "vscode-fileutils";
      publisher = "sleistner";
      version = "3.3.3";
      sha256 = "18a3zbb80gb57xss9921jnzl38kw5jab6jjajnwyv0k0kjca0440";
    };
    arrterian.nix-env-selector = mp {
      name = "nix-env-selector";
      publisher = "arrterian";
      version = "0.1.2";
      sha256 = "1n5ilw1k29km9b0yzfd32m8gvwa2xhh6156d4dys6l8sbfpp2cv9";
    };
    brettm12345.nixfmt-vscode = mp {
      name = "nixfmt-vscode";
      publisher = "brettm12345";
      version = "0.0.1";
      sha256 = "07w35c69vk1l6vipnq3qfack36qcszqxn8j3v332bl0w6m02aa7k";
    };
    christian-kohler.path-intellisense = mp {
      name = "path-intellisense";
      publisher = "christian-kohler";
      version = "2.3.0";
      sha256 = "1wyp3k4gci1i64nrry12il6yflhki18gq2498z3nlsx4yi36jb3l";
    };
    ms-python = {
      python = mp {
        name = "python";
        publisher = "ms-python";
        version = "2020.10.332292344";
        sha256 = "0c43njzbbg6hgv7cppiilvq77vlvd9kcr7fzl88g7f2y7xczy2ma";
      };
      vscode-pylance = mp {
        name = "vscode-pylance";
        publisher = "ms-python";
        version = "2020.10.3";
        sha256 = "13n5pk3zj7c0l442qpzgirx23m0jliwwkr9drzm84193rbgm6kl8";
      };
    };
    gruntfuggly.todo-tree = mp {
      name = "todo-tree";
      publisher = "gruntfuggly";
      version = "0.0.186";
      sha256 = "0frnfimvv2862bb85jgyvbky90xpxx584mir9k2fsgii1rxmv6dr";
    };
    mksafi.find-jump = mp {
      name = "find-jump";
      publisher = "mksafi";
      version = "1.2.4";
      sha256 = "1qk2sl3dazna3zg6nq2m7313jdl67kxm5d3rq0lfmi6k1q2h9sd7";
    };
    wmaurer.vscode-jumpy = mp {
      name = "vscode-jumpy";
      publisher = "wmaurer";
      version = "0.3.1";
      sha256 = "1mrjg1swlpscfxdfqpv4vpyhamr1h4rd39pz06dgqrjqmggz52fy";
    };
    scala-lang.scala = mp {
      name = "scala";
      publisher = "scala-lang";
      version = "0.4.5";
      sha256 = "0nrj32a7a86vwc9gfh748xs3mmfwbc304dp7nks61f0lx8b4wzxw";
    };
    justusadam.language-haskell = mp {
      name = "language-haskell";
      publisher = "justusadam";
      version = "3.3.0";
      sha256 = "1285bs89d7hqn8h8jyxww7712070zw2ccrgy6aswd39arscniffs";
    };
    sabieber.hocon = mp {
      name = "hocon";
      publisher = "sabieber";
      version = "0.0.1";
      sha256 = "0mgyj7kxsx4acxc9nx63pwcwp9ckvrawj9pjln8wrnj5w9cdvbcv";
    };
    sets = (with vscode-extensions; {
      haskell = [ alanz.vscode-hie-server justusadam.language-haskell ];
      python = [ ms-python.python ms-python.vscode-pylance ];
      rust = [ matklad.rust-analyzer ms-vscode.cpptools ];
      scala = [ sabieber.hocon scala-lang.scala scalameta.metals ];
    });
  };
}
