{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    newSession = true;
    extraConfig = ''
      ###############
      ### Plugins ###
      ###############

      run-shell ${pkgs.tmuxPlugins.fpp}/share/tmux-plugins/fpp/fpp.tmux
      run-shell ${pkgs.tmuxPlugins.sensible}/share/tmux-plugins/sensible/sensible.tmux

      ###############
      ### GENERAL ###
      ###############

      # Enable mouse mode (tmux 2.1 and above)
      set -g mouse on

      # don't rename windows automatically
      set-window-option -g automatic-rename off
      set-option -g allow-rename off

      # Set repeat-time to one second
      set -g status-interval 1
      set -sg escape-time 1

      # loud or quiet?
      set-window-option -g monitor-activity off
      set-option -g visual-activity off
      set-option -g visual-silence off
      set-option -g visual-bell off
      set-option -g bell-action none

      ####################
      ### KEY BINDINGS ###
      ####################

      # # switch panes using Alt-Shift-$arrow without prefix
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

      # The modes
      setw -g clock-mode-colour colour135

      # The statusbar
      set -g status-position bottom
      set -g status-bg colour234
      set -g status-fg colour137
      set -g status-left '''
      set -g status-right '#[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S '
      set -g status-right-length 50
      set -g status-left-length 20

      # The window status
      set-window-option -g window-status-current-format '#[fg=white,bold][#{window_index}] #[fg=green]#{pane_current_command} #[fg=cyan]#(pwd="#{pane_current_path}"; echo ''${pwd####*/}) '
      set-window-option -g window-status-format '#[fg=colour244,bold][#{window_index}] #[fg=colour244]#{pane_current_command} #[fg=colour244]#(pwd="#{pane_current_path}"; echo ''${pwd####*/}) '
    '';
  };
}
