{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    extraTmuxConf = ''
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

			# reload config file (change file location to your the tmux.conf you want to use)
			bind r source-file ~/.tmux.conf \; display "Config reloaded"

			# # switch panes using Alt-Shift-$arrow without prefix
			bind -n M-Left select-pane -L
			bind -n M-Right select-pane -R
			bind -n M-Up select-pane -U
			bind -n M-Down select-pane -D

			# split panes using | and -
			bind | split-window -h
			bind - split-window -v
			unbind '"'
			unbind %

			######################
			### DESIGN CHANGES ###
			######################

			# The modes
			setw -g clock-mode-colour colour135
			setw -g mode-attr bold
			setw -g mode-fg colour196
			setw -g mode-bg colour238

			# The panes
			set -g pane-border-bg colour235
			set -g pane-border-fg colour238
			set -g pane-active-border-bg colour236
			set -g pane-active-border-fg colour51

			# The statusbar
			set -g status-position bottom
			set -g status-bg colour234
			set -g status-fg colour137
			set -g status-attr dim
			set -g status-left '''
			set -g status-right '#[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S '
			set -g status-right-length 50
			set -g status-left-length 20

			# The window status
			set-window-option -g window-status-current-format '#[fg=white,bold][#{window_index}] #[fg=green]#{pane_current_command} #[fg=cyan]#(pwd="#{pane_current_path}"; echo ''${pwd####*/}) '
			set-window-option -g window-status-format '#[fg=colour244,bold][#{window_index}] #[fg=colour244]#{pane_current_command} #[fg=colour244]#(pwd="#{pane_current_path}"; echo ''${pwd####*/}) '
			setw -g window-status-current-fg colour81
			setw -g window-status-current-bg colour238
			setw -g window-status-current-attr bold
			setw -g window-status-fg colour138
			setw -g window-status-bg colour235
			setw -g window-status-attr none
			setw -g window-status-bell-attr bold
			setw -g window-status-bell-fg colour255
			setw -g window-status-bell-bg colour1

			# The messages
			set -g message-attr bold
			set -g message-fg colour232
			set -g message-bg colour166
    '';
  };
}