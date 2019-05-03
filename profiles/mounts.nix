{ pkgs, ... }:
let
  secrets = import ../secrets;
in
{
  environment.systemPackages = with pkgs; [
    cifs-utils
    ntfs3g
  ];

  systemd.mounts = [
    { what = "//192.168.68.6/aim";
      where = "/media/fs/aim";
      type = "cifs";
      mountConfig = {
        TimeoutSec = "3";
        Options = "user,gid=users,rw,credentials=${secrets.aimSMBCredentialsFile},file_mode=0774,dir_mode=0774";
      };
    }
    { what = "//192.168.68.6/Teamordner";
      where = "/media/fs/teamordner";
      type = "cifs";
      mountConfig = {
        TimeoutSec = "3";
        Options = "user,gid=users,rw,credentials=${secrets.aimSMBCredentialsFile},file_mode=0774,dir_mode=0774";
      };
    }
    { what = "//192.168.68.6/aim/Kundenprojekte/AllgemeinesMavenRepo/aim-fs-maven-repo";
      where = "/media/fs/aim_fs_maven_repo";
      type = "cifs";
      mountConfig = {
        TimeoutSec = "3";
        Options = "user,gid=users,rw,credentials=${secrets.aimSMBCredentialsFile},file_mode=0774,dir_mode=0774";
      };
    }
    { what = "//192.168.68.6/ML_Projects/Cliplister";
      where = "/media/fs/ml_cliplister";
      type = "cifs";
      mountConfig = {
        TimeoutSec = "3";
        Options = "user,gid=users,rw,credentials=${secrets.aimSMBCredentialsFile},file_mode=0774,dir_mode=0774";
      };
    }
  ];
}
