export EDITOR=micro
export VISUAL=micro
export PAGER=more
export PROJECT_HOME=$HOME/Projects
export MICRO_TRUECOLOR=1
export REVIEW_BASE=master

export ZPLUG_HOME=$HOME/.zplug
export TPM_HOME=$HOME/.tmux/plugins/tpm

export NNN_FALLBACK_OPENER=xdg-open
export NNN_DE_FILE_MANAGER=nautilus

export ZFUNC_DIR=$HOME/.zfunc 
export FPATH=$ZFUNC_DIR:$FPATH

export MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
export SBT_OPTS="-XX:+CMSClassUnloadingEnabled -Xmx2G" 

# Conditional PATH additions
for path_candidate in \
  ~/.local/bin \
  ~/.npm-packages/bin \
  ~/.cargo/bin \
  ~/.go/bin \
  ~/bin

do
  if [ -d ${path_candidate} ]; then
    export PATH=${path_candidate}:${PATH}
  fi
done
