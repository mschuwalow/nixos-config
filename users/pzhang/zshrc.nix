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
      clear && printf '\033[2J\033[3J\033[1;1H'

      # clear terminal and tmux scrollback if tmux is used
      if [[ ! -z "$TMUX" ]]; then
          tmux clear-history
      fi
    }
  '';

  cdd = pkgs.writeText "cdd.zsh" ''
    #!${pkgs.zsh}/bin/zsh

    cdd () {
      cd "$*"
      ls -lACh --color
    }
  '';

  self = pkgs.writeText "zshrc" ''
    # Clone zplug if you haven't already
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
    zplug 'robbyrussell/oh-my-zsh', use:'lib/*.zsh'

    # load OMZsh plugins
    zplug 'plugins/git', from:oh-my-zsh
    zplug 'plugins/sudo', from:oh-my-zsh
    zplug 'plugins/command-not-found', from:oh-my-zsh
    zplug 'plugins/history-substring-search', from:oh-my-zsh
    zplug 'plugins/docker', from:oh-my-zsh
    zplug 'plugins/docker-compose', from:oh-my-zsh

    # load commands
    zplug 'k4rthik/git-cal', as:command
    zplug 'knu/z', as:command, use:'z.sh'
    zplug 'b4b4r07/httpstat', as:command, use:'(*).sh', rename-to:'$1'
    zplug 'johanhaleby/kubetail', as:command
    zplug 'c-bata/kube-prompt', as:command, from:gh-r, use:'*linux*amd64*'
    zplug 'astefanutti/kubebox', as:command, from:gh-r, use:'*linux*'
    zplug 'deltaroe/63afd52ba84274ed5b86ba9b0c357e8f', as:command, from:gist, use:'add-ns.py', rename-to:'k8s-add-namespace'

    # load completions
    zplug 'zsh-users/zsh-completions'
    zplug 'Schnouki/git-annex-zsh-completion'

    # load other plugins
    zplug 'junegunn/fzf', use:'shell/{completion.zsh,key-bindings.zsh}'
    zplug 'andrewferrier/fzf-z'
    zplug 'l4u/zsh-output-highlighting'
    zplug 'changyuheng/zsh-interactive-cd'
    zplug 'zsh-users/zsh-syntax-highlighting', defer:2
    zplug 'zpm-zsh/autoenv'    

    # Install plugins if there are plugins that have not been installed
    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
    fi

    # then, source plugins and add commands to $PATH
    zplug load

    # Set theme. To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
    source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

    ####################
    # Custom Functions #
    ####################

    # load functions
    source ${tcon}
    source ${cls}
    source ${cdd}

    # custom options
    setopt HIST_IGNORE_ALL_DUPS
    setopt HIST_IGNORE_SPACE
    setopt AUTO_CD
    unsetopt LIST_BEEP

    # style
    zstyle ':completion:*' rehash true
    zstyle ':completion:*:descriptions' format '%B%d%b'
    zstyle ':completion:*:messages' format '%d'
    zstyle ':completion:*' group-name '''

    ###############
    # Keybindings #
    ###############

    # Custom Keybindings
    bindkey '\eOA' history-substring-search-up
    bindkey '\eOB' history-substring-search-down

    bindkey '^R' fzf-history-widget # gets overridden by something
  '';
in self
