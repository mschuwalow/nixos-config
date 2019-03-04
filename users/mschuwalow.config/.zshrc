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
  git clone https://github.com/zplug/zplug.git $ZPLUG_HOME
fi

# load zplug
source "${ZPLUG_HOME}/init.zsh"

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

####################
# Custom Functions #
####################

# Autoload
if [[ ! -z "$ZFUNC_DIR" ]]; then
  autoload -Uz $(ls $ZFUNC_DIR)
fi

autoload zmv

############
# Settings #
############

# Fzf
FZF_DEFAULT_OPTS='--height 80% --reverse'
FZFZ_EXTRA_DIRS="$PROJECT_HOME"

# Reverse search
HISTSIZE=50000
SAVEHIST=10000

HISTFILE=~/.zsh_history

# Custom Options
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt AUTO_CD

# Style 
zstyle ':completion:*' rehash true
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*' group-name ''

###############
# Keybindings #
###############

# Custom Keybindings
bindkey '\eOA' history-substring-search-up 
bindkey '\eOB' history-substring-search-down 

###########
# Aliases #
###########

# Set Aliases
alias ll="exa -lhg --git"
alias la="exa -lahg --git"
alias dc="docker-compose"
alias lsp-py="pyls --tcp --port 8081"
unalias gr

###########
# Startup #
###########

# load direnv
eval "$(direnv hook zsh)"
