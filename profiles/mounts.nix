{ pkgs, ... }:
let
  secrets = import ../secrets;
in
{
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  systemd.mounts = [
    { what = "//192.168.68.6/aim";
      where = "/media/fs/aim";
      type = "cifs";
      mountConfig = {
        TimeoutSec = "1";
        Options = "user,gid=users,rw,credentials=${secrets.aimSMBCredentialsFile}";
      };
    }
    { what = "//192.168.68.6/Teamordner";
      where = "/media/fs/teamordner";
      type = "cifs";
      mountConfig = {
        TimeoutSec = "1";
        Options = "user,gid=users,rw,credentials=${secrets.aimSMBCredentialsFile}";
      };
    }
    { what = "//192.168.68.6/aim/Kundenprojekte/AllgemeinesMavenRepo/aim-fs-maven-repo";
      where = "/media/fs/aim-fs-maven-repo";
      type = "cifs";
      mountConfig = {
        TimeoutSec = "1";
        Options = "user,gid=users,rw,credentials=${secrets.aimSMBCredentialsFile}";
      };
    }
    { what = "//192.168.68.6/ML_Projects/Cliplister";
      where = "/media/fs/ML_Cliplister";
      type = "cifs";
      mountConfig = {
        TimeoutSec = "1";
        Options = "user,gid=users,rw,credentials=${secrets.aimSMBCredentialsFile}";
      };
    }
  ];
}
