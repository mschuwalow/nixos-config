{ pkgs, ... }:
let

tcon = pkgs.writeText "tcon.zsh" ''
  #!${pkgs.zsh}/bin/zsh

  tcon () {
    # Attach to running tmux sessions
    if [[ -z "$TMUX" ]]; then
      local tmux=${pkgs.tmux}/bin/tmux
      local base_session='base'

      # Create a new session if it doesn't exist
      $tmux has-session -t $base_session &> /dev/null || $tmux new-session -d -s $base_session

      # Get ids of connected clients.
      sessions=$($tmux list-sessions -F "#{session_group}-#{session_id}" 2> /dev/null | grep $base_session | sed "s/''${base_session}-\\$//")
      
      # get the maximum id from clients. The base session will always have an id).
      local max_id=$(echo ''${sessions[@]} | sort -n | tail -n1)
      # max_id=''${max_id:=-1}
    
      # create a new session with max_id+1 (or 0 if no clients were found) and link it to the base session
      local session_name=$base_session"-"$((max_id+1))}
      $tmux new-session -d -t $base_session -s $session_name
      $tmux -2 attach-session -t $session_name \; set-option destroy-unattached
        
    else
      echo "Can't start nested sessions."
    fi
  }
'';

cls = pkgs.writeText "cls.zsh" ''
  #!${pkgs.zsh}/bin/zsh

  cls () {
    clear

    # clear terminal and tmux scrollback if tmux is used
    if [[ ! -z "$TMUX" ]]; then
      ${pkgs.tmux}/bin/tmux clear-history
    else
      echo "Can't start nested sessions."
    fi
  }
'';

self = pkgs.writeText "zshrc" ''
  #########
  # zplug #
  #########

  # Clone zgen if you haven't already
  if [[ -z "$ZPLUG_HOME" ]]; then
    export ZPLUG_HOME=$HOME/.zplug
  fi
  if [[ ! -f $ZPLUG_HOME/init.zsh ]]; then
    if [[ ! -d "$ZPLUG_HOME" ]]; then
      mkdir -p "$ZPLUG_HOME"
    fi
    ${pkgs.git}/bin/git clone https://github.com/zplug/zplug.git $ZPLUG_HOME
  fi

  # load zplug
  source "''${ZPLUG_HOME}/init.zsh"

  # load OMZsh components
  # zplug "robbyrussell/oh-my-zsh", use:"lib/*\.zsh"

  # load OMZsh plugins
  zplug "plugins/git", from:oh-my-zsh
  zplug "plugins/sudo", from:oh-my-zsh
  zplug "plugins/command-not-found", from:oh-my-zsh
  zplug "plugins/history-substring-search", from:oh-my-zsh
  zplug "plugins/docker", from:oh-my-zsh
  zplug "plugins/docker-compose", from:oh-my-zsh

  # load commands
  zplug "k4rthik/git-cal", as:command
  zplug "rupa/z", as:command, use:'z.sh', rename-to:'z'
  zplug "c-bata/kube-prompt", as:command, from:gh-r, use:"*linux*amd64*"
  zplug "astefanutti/kubebox", as:command, from:gh-r, use:"*linux*"
  zplug "deltaroe/63afd52ba84274ed5b86ba9b0c357e8f", as:command, from:gist, use:"add-ns.py", rename-to:"k8s-add-namespace"

  # load completions
  zplug "zsh-users/zsh-completions"
  zplug "Schnouki/git-annex-zsh-completion"

  # load other plugins
  zplug "junegunn/fzf", use:"shell/{completion.zsh,key-bindings.zsh}"
  zplug "andrewferrier/fzf-z"
  zplug "l4u/zsh-output-highlighting"
  zplug "changyuheng/zsh-interactive-cd"
  zplug "zsh-users/zsh-syntax-highlighting", defer:2

  # set theme
  zplug 'themes/clean', from:oh-my-zsh, as:theme

  # Install plugins if there are plugins that have not been installed
  if ! zplug check --verbose; then
      printf "Install? [y/N]: "
      if read -q; then
          echo; zplug install
      fi
  fi

  # Then, source plugins and add commands to $PATH
  zplug load

  source ${tcon}
  source ${cls}
'';
in
self