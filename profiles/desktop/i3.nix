{ pkgs, ... }:
let
  i3status = pkgs.callPackage (import ./i3status.nix) { };

  cmds = {
    alacritty = "${pkgs.alacritty}/bin/alacritty";
    amixer = "${pkgs.alsaUtils}/bin/amixer";
    bash = "${pkgs.bash}/bin/bash";
    feh = "${pkgs.feh}/bin/feh";
    i3lock = "${pkgs.i3lock}/bin/i3lock";
    killall = "${pkgs.killall}/bin/killall";
    maim = "${pkgs.maim}/bin/maim";
    pacmd = "${pkgs.pulseaudio}/bin/pacmd";
    pactl = "${pkgs.pulseaudio}/bin/pactl";
    pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
    playerctl = "${pkgs.playerctl}/bin/playerctl";
    python3 = "${pkgs.python3}/bin/python";
    rofi = "${pkgs.rofi}/bin/rofi";
    xbacklight = "${pkgs.xorg.xbacklight}/bin/xbacklight";
  };

  i3next = pkgs.writeScript "i3next.sh" ''
    #!${cmds.bash}

    case "$1" in
      new)
        i3-msg workspace $(($(i3-msg -t get_workspaces | tr , '\n' | grep '"num":' | cut -d : -f 2 | sort -rn | head -1) + 1))
        ;;
      move)
        workspace=$(($(i3-msg -t get_workspaces | tr , '\n' | grep '"num":' | cut -d : -f 2 | sort -rn | head -1) + 1))
        i3-msg move container to workspace $workspace
        i3-msg workspace $workspace
        ;;
      *)
        echo "Usage: $0 [new|move]"
        exit 2
    esac

    exit 0
  '';

  i3lock = pkgs.writeScript "i3lock.sh" ''
    #!${cmds.bash}
    set -eu

    ${cmds.i3lock} -n -t -f -d -i ${pkgs.copyPathToStore ./lock.png}
  '';

  i3exit = pkgs.writeScript "i3exit.sh" ''
    #!${cmds.bash}

    case "$1" in
      lock)
        # when not using lightdm
        # ${i3lock} lock
        dm-tool lock
        ;;
      logout)
        i3-msg exit
        ;;
      suspend)
        systemctl suspend
        ;;
      hibernate)
        systemctl hibernate
        ;;
      reboot)
        systemctl reboot
        ;;
      shutdown)
        systemctl poweroff
        ;;
      *)
        echo "Usage: $0 [lock|suspend|hibernate|reboot|shutdown]"
        exit 2
    esac
    exit 0
  '';

  i3new = pkgs.writeScript "i3new.sh" ''
    #!${cmds.bash}
    case "$1" in
      new)
        i3-msg workspace $(($(i3-msg -t get_workspaces | tr , '\n' | grep '"num":' | cut -d : -f 2 | sort -rn | head -1) + 1))
        ;;
      move)
        workspace=$(($(i3-msg -t get_workspaces | tr , '\n' | grep '"num":' | cut -d : -f 2 | sort -rn | head -1) + 1))
        i3-msg move container to workspace $workspace
        i3-msg workspace $workspace
        ;;
      *)
        echo "Usage: $0 [new|move]"
        exit 2
    esac
    exit 0
  '';

  volumeControl = pkgs.writeScript "volumeControl.sh" ''
    #!${cmds.python3}
    import subprocess
    import sys

    def run(command):
      call = subprocess.Popen(command, shell = True, stdout = subprocess.PIPE)
      stdout = call.communicate()[0]
      return stdout.strip().decode('utf-8'), call.returncode

    def get_active_sink():
      return run('${cmds.pacmd} list-sinks | grep "* index" | awk \'{print $3}\''')[0]

    def get_volume():
      return run('${cmds.amixer} get Master | grep -o "\[.*%\]" | grep -o "[0-9]*" | head -n1')[0]

    def set_volume(percentage):
      run('${cmds.pactl} set-sink-volume ' + get_active_sink() + ' ' + str(percentage) + '%')
      emit_signal()

    def toggle_volume():
      run('${cmds.amixer} set Master Playback Switch toggle')
      emit_signal()

    def is_muted():
      return not run('${cmds.amixer} get Master | grep -o "\[on\]" | head -n1')[0]

    def write(message):
      sys.stdout.write(message)
      sys.stdout.flush()

    def trim_to_range(volume):
      volume = int(volume)
      if volume < 0:
        volume = 0
      elif volume > 200:
        volume = 200
      return volume

    def status():
      if int(get_volume()) == 0 or is_muted():
        return 'muted'
      else:
        return 'on'

    def emit_signal():
      run("${cmds.killall} -USR1 -r '.*py3status.*'")

    if __name__ == '__main__':
      command = sys.argv[1]

      if command == 'set':
        set_volume(trim_to_range(sys.argv[2]))
      elif command == 'up':
        new_volume = trim_to_range(int(get_volume()) + int(sys.argv[2]))
        set_volume(new_volume)
      elif command == 'down':
        new_volume = trim_to_range(int(get_volume()) - int(sys.argv[2]))
        set_volume(new_volume)
      elif command == 'toggle':
        toggle_volume()
      elif command == 'read':
        write(get_volume())
      elif command == 'status':
        write(status())
      elif command == 'i3blocks':
        output = get_volume() + '%'
        if is_muted():
          output += '\n\n#dd3333'
        write(output)
      elif command == 'signal':
        emit_signal()
      else:
        write('Usage: ' + sys.argv[0] + ' [set|up|down|toggle|read|status] [value]\n')
  '';

  self = pkgs.writeText "i3.conf" ''
    # i3 config file (v4)
    #
    # Please see http://i3wm.org/docs/userguide.html for a complete reference!

    ### Variables
    #

    # Logo key. Use Mod1 for Alt.
    set $mod Mod4

    # Your preferred terminal emulator
    set $term ${cmds.alacritty}

    # fonts
    font pango:SauceCodePro Nerd Font Semibold 0
    set $bar-font pango:SauceCodePro Nerd Font Semibold 10

    set $border_pixels 3

    force_display_urgency_hint 0 ms
    focus_on_window_activation urgent

    workspace_auto_back_and_forth no
    floating_modifier $mod

    ### Key bindings
    #
    # Basics:
    #
    # start a terminal
    bindsym $mod+Return exec --no-startup-id $term

    # kill focused window
    bindsym $mod+Shift+q kill

    # start your launcher
    bindsym $mod+d exec --no-startup-id ${cmds.rofi} -show drun
    bindsym $mod+Shift+Tab exec --no-startup-id ${cmds.rofi} -show window

    # reload the configuration file
    bindsym $mod+Shift+c reload
    #
    # Moving around:
    #
    bindsym $mod+Left focus left
    bindsym $mod+Right focus right
    bindsym $mod+Down focus down
    bindsym $mod+Up focus up

    bindsym $mod+Shift+Left move left
    bindsym $mod+Shift+Right move right
    bindsym $mod+Shift+Down move down
    bindsym $mod+Shift+Up move up

    bindsym $mod+Mod1+Left move workspace to output left
    bindsym $mod+Mod1+Right move workspace to output right
    bindsym $mod+Mod1+Down move workspace to output down
    bindsym $mod+Mod1+Up move workspace to output up
    #
    # Workspaces:
    #
    bindsym $mod+Tab workspace back_and_forth
    # Rename workspace with i3-input using numbers and text

    # set Workspace names
    set $ws1  "1: Ⅰ "
    set $ws2  "2: Ⅱ "
    set $ws3  "3: Ⅲ "
    set $ws4  "4: Ⅳ "
    set $ws5  "5: Ⅴ "
    set $ws6  "6: Ⅵ "
    set $ws7  "7: Ⅶ "
    set $ws8  "8: Ⅷ "
    set $ws9  "9: Ⅸ "
    set $ws10 "10: Ⅹ "

    # switch to workspace
    bindsym $mod+1 workspace $ws1
    bindsym $mod+2 workspace $ws2
    bindsym $mod+3 workspace $ws3
    bindsym $mod+4 workspace $ws4
    bindsym $mod+5 workspace $ws5
    bindsym $mod+6 workspace $ws6
    bindsym $mod+7 workspace $ws7
    bindsym $mod+8 workspace $ws8
    bindsym $mod+9 workspace $ws9
    bindsym $mod+0 workspace $ws10

    # move focused container to workspace
    bindsym $mod+Shift+1 move container to workspace $ws1
    bindsym $mod+Shift+2 move container to workspace $ws2
    bindsym $mod+Shift+3 move container to workspace $ws3
    bindsym $mod+Shift+4 move container to workspace $ws4
    bindsym $mod+Shift+5 move container to workspace $ws5
    bindsym $mod+Shift+6 move container to workspace $ws6
    bindsym $mod+Shift+7 move container to workspace $ws7
    bindsym $mod+Shift+8 move container to workspace $ws8
    bindsym $mod+Shift+9 move container to workspace $ws9
    bindsym $mod+Shift+0 move container to workspace $ws10

    bindsym $mod+n exec --no-startup-id ${i3new} new
    bindsym $mod+Shift+n exec --no-startup-id ${i3new} move
      
    #
    # Layout stuff:
    #
    # You can "split" the current object of your focus with
    # $mod+b or $mod+v, for horizontal and vertical splits
    # respectively.
    bindsym $mod+b splith
    bindsym $mod+v splitv

    # Switch the current container between different layout styles
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split

    # Make the current focus fullscreen
    bindsym $mod+f fullscreen

    # Toggle the current focus between tiling and floating mode
    bindsym $mod+Shift+space floating toggle

    # Swap focus between the tiling area and the floating area
    bindsym $mod+space focus mode_toggle

    # move focus to the parent container
    bindsym $mod+a focus parent
    #
    # Scratchpad:
    #
    # Sway has a "scratchpad", which is a bag of holding for windows.
    # You can send windows there and get them back later.

    # Move the currently focused window to the scratchpad
    bindsym $mod+Shift+minus move scratchpad

    # Show the next scratchpad window or hide the focused scratchpad window.
    # If there are multiple scratchpad windows, this command cycles through them.
    bindsym $mod+minus scratchpad show

    #
    # Volume and Media:
    #
    bindsym XF86AudioLowerVolume exec --no-startup-id ${volumeControl} down 5
    bindsym XF86AudioRaiseVolume exec --no-startup-id ${volumeControl} up 5
    bindsym XF86AudioMute exec --no-startup-id ${volumeControl} toggle

    # Media player controls
    bindsym XF86AudioPlay      exec ${cmds.playerctl} play-pause
    bindsym XF86AudioPause     exec ${cmds.playerctl} play-pause
    bindsym XF86AudioPlayPause exec ${cmds.playerctl} play-pause
    bindsym XF86AudioNext      exec ${cmds.playerctl} next
    bindsym XF86AudioPrev      exec ${cmds.playerctl} previous

    #
    # Other:
    #

    # Brightnes
    bindsym XF86MonBrightnessDown exec --no-startup-id ${cmds.xbacklight} -dec 10
    bindsym XF86MonBrightnessUp exec --no-startup-id ${cmds.xbacklight} -inc 10

    bindsym $mod+Shift+w exec --no-startup-id $term -t "__nmtui" -e "nmtui"
    bindsym $mod+Shift+v exec ${cmds.pavucontrol}

    # screenshot
    bindsym $mod+Print exec ${cmds.maim} $HOME/Pictures/screenshots/screenshot-$(date +%Y-%m-%d_%H-%M-%S).png

    set $mode_resize resize
    bindsym $mod+Shift+r mode "$mode_resize"
    mode "$mode_resize" {
      bindsym Left resize shrink width 10 px or 1 ppt
      bindsym Down resize grow height 10 px or 1 ppt
      bindsym Up resize shrink height 10 px or 1 ppt
      bindsym Right resize grow width 10 px or 1 ppt

      bindsym Shift+Left resize shrink width 20 px or 5 ppt
      bindsym Shift+Down resize grow height 20 px or 5 ppt
      bindsym Shift+Up resize shrink height 20 px or 5 ppt
      bindsym Shift+Right resize grow width 20 px or 5 ppt

      bindsym 1 mode "default", resize set 1000 600
      bindsym 2 mode "default", resize set 1500 600
      bindsym 3 mode "default", resize set 1200 1000

      bindsym Return mode "default"
      bindsym Escape mode "default"
    }

    set $mode_power power
    bindsym $mod+Shift+l mode "$mode_power"
    mode "$mode_power" {
      bindsym l mode "default", exec --no-startup-id ${i3exit} lock
      bindsym e mode "default", exec --no-startup-id ${i3exit} logout
      bindsym s mode "default", exec --no-startup-id ${i3exit} suspend
      bindsym h mode "default", exec --no-startup-id ${i3exit} hibernate
      bindsym r mode "default", exec --no-startup-id ${i3exit} reboot
      bindsym p mode "default", exec --no-startup-id ${i3exit} shutdown

      bindsym Return mode "default"
      bindsym Escape mode "default"
    }

    ### Other stuff
    #
    # fix graphics glitches
    #

    new_window none
    for_window [class="^.*"] border pixel $border_pixels

    for_window [window_role="pop-up"] floating enable
    for_window [window_role="bubble"] floating enable
    for_window [window_role="task_dialog"] floating enable
    for_window [window_role="Preferences"] floating enable
    for_window [window_type="menu"] floating enable
    for_window [window_type="dialog"] floating enable
    for_window [class="(?i)albert"] floating enable
    for_window [class="Org.gnome.Nautilus"] floating enable

    for_window [class="(?i)gsimplecal"] floating enable, move position mouse

    for_window [class="(?i)qemu-system"] floating enable
    for_window [class="(?i)qemu"] floating enable
    for_window [class="(?i)VirtualBox" title="(?i)Manager"] floating enable
    for_window [class="(?i)blueman"] floating enable
    for_window [class="(?i)VMWare"] floating enable
    for_window [class="Seafile Client"] floating enable
    for_window [class="Fcitx-config-gtk3"] floating enable

    for_window [class="(?i)Skype"] layout stacking 

    for_window [instance="__scratchpad"] floating enable
    for_window [instance="__nmtui"] floating enable
    for_window [instance="__cmst"] floating enable

    for_window [class="(?i)pavucontrol"] floating enable, resize set 1000 700, move position mouse
    for_window [class="(?i)pavucontrol" instance="pavucontrol-bar"] move down 34p 

    # jetbrains
    for_window [class="^jetbrains-.+"][window_type=dialog] focus
    for_window [instance="sun-awt-X11-XWindowPeer"] border pixel 0

    #
    # Autostart
    #

    exec --no-startup-id ${pkgs.seafile-client}/bin/seafile-applet
    exec --no-startup-id ${pkgs.networkmanagerapplet}/bin/nm-applet
    exec --no-startup-id ${pkgs.fcitx}/bin/fcitx

    # set background
    exec_always --no-startup-id ${cmds.feh} --bg-tile --no-xinerama ${pkgs.copyPathToStore ./wallpaper.png}

    bar {
      status_command ${i3status}
      i3bar_command i3bar
      position bottom
      tray_output primary
      font $bar-font
      strip_workspace_numbers yes
      bindsym button4 nop
      bindsym button5 nop
      tray_padding 2
      colors {
        background #222222
        statusline #dddddd
        separator #666666
        focused_workspace #0088CC #0088CC #ffffff
        active_workspace #333333 #333333 #888888
        inactive_workspace #333333 #333333 #888888
        urgent_workspace   #2f343a #900000 #ffffff
      }
    }
  '';
in self
