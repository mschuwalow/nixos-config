{ pkgs, ... }:
let
  loadPlugin = plugin: "run-shell ${plugin.rtp}";
in
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    newSession = true;
    terminal = "tmux-256color";
    extraConfig = ''
      ###############
      ### Plugins ###
      ###############

      ${loadPlugin pkgs.tmuxPlugins.sensible}
      ${loadPlugin pkgs.tmuxPlugins.pain-control}
      ${loadPlugin pkgs.tmuxPlugins.extrakto}
      ${loadPlugin pkgs.tmuxPlugins.resurrect}
      ${loadPlugin pkgs.tmuxPlugins.onedark-theme}

      ###############
      ### GENERAL ###
      ###############

      # Enable mouse mode (tmux 2.1 and above)
      set -g mouse on

      # don't rename windows automatically
      set-window-option -g automatic-rename off
      set-option -g allow-rename off

      ####################
      ### KEY BINDINGS ###
      ####################

      # set prefix to c-a
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix

      # switch panes using Alt-Shift-$arrow without prefix
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # fix scrolling to go one line at a time
      bind -Tcopy-mode WheelUpPane send -N1 -X scroll-up
      bind -Tcopy-mode WheelDownPane send -N1 -X scroll-down

      ######################
      ### DESIGN CHANGES ###
      ######################

      set -g @onedark_widgets "#(date +%s)"
    '';
  };
}
