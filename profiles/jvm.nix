{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    coursier
    idea.idea-community
    jd-gui
    visualvm
    (sbt-extras.override { jdk = jdk8; })
  ];

  programs.java = {
    enable = true;
    package = pkgs.openjdk8;
  };

  services.bloop-system = {
    enable = false; # todo: figure out how to fix socket permissions.
    extraOptions =
      [ "-J-Xmx2G" "-J-XX:MaxInlineLevel=20" "-J-XX:+UseParallelGC" ];
    javaPackage = pkgs.openjdk11;
  };
}
