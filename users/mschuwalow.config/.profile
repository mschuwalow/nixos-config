export EDITOR='micro'
export VISUAL='micro'
export PROJECT_HOME=$HOME/Projects
export MICRO_TRUECOLOR=1
export REVIEW_BASE='master'

export ZPLUG_HOME=$HOME/.zplug
export TPM_HOME=$HOME/.tmux/plugins/tpm

# Conditional PATH additions
for path_candidate in \
  /snap/bin \
  ~/.local/bin \
  ~/.npm-packages/bin \
  ~/.cargo/bin \
  ~/.go/bin \
  ~/.local/share/umake/nodejs/nodejs-lang/bin \
  ~/.local/share/umake/go/go-lang/bin \
  ~/.local/share/umake/bin \
  ~/tools/maven3/bin \
  ~/bin

do
  if [ -d ${path_candidate} ]; then
    export PATH=${path_candidate}:${PATH}
  fi
done
