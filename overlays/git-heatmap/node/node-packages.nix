# This file has been generated by node2nix 1.9.0. Do not edit!

{ nodeEnv, fetchurl, fetchgit, nix-gitignore, stdenv, lib
, globalBuildInputs ? [ ] }:

let
  sources = {
    "minimist-1.2.5" = {
      name = "minimist";
      packageName = "minimist";
      version = "1.2.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/minimist/-/minimist-1.2.5.tgz";
        sha512 =
          "FM9nNUYrRBAELZQT3xeZQ7fmMOBg6nWNmJKTcgsJeaLstP/UODVpGsr5OhXhhXg6f+qtJ8uiZ+PUxkDWcgIXLw==";
      };
    };
    "printf-0.1.3" = {
      name = "printf";
      packageName = "printf";
      version = "0.1.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/printf/-/printf-0.1.3.tgz";
        sha1 = "27e935bae4f55db1fdc18368689e9561ce551226";
      };
    };
  };
in {
  "bars-git://github.com/jez/bars.git" = nodeEnv.buildNodePackage {
    name = "bars";
    packageName = "bars";
    version = "1.2.2";
    src = fetchgit {
      url = "git://github.com/jez/bars.git";
      rev = "d2047be60a2762f09ae2ff8b8e3c517764c02dee";
      sha256 =
        "1053580f939ce7a37df7c768605a9d9ec9412ef38e785d07aacfb4d09cb4d056";
    };
    dependencies = [ sources."minimist-1.2.5" sources."printf-0.1.3" ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "Ascii bar charting";
      license = "MIT";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
}
