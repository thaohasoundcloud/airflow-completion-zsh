TODO: Delete dags in .airflow_completion file
Settings in .zshrc
```bash
# COMPLETION SETTINGS
# add custom completion scripts
fpath=(/Users/thaoha/soundcloud/code/completion $fpath)

# show completion menu when number of options is at least 2
# zstyle ':completion:*' menu select=2
# compsys initialization
autoload -U compinit
compinit
# autoload -U compinit && compinit
# autoload -U bashcompinit && bashcompinit
```

Run `exec zsh` to apply changes
