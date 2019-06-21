# Airflow completion

### Configuration

1. Settings in .zshrc
```bash
# COMPLETION SETTINGS
# add custom completion scripts
fpath=(<your_completion_folder> $fpath)

# show completion menu when number of options is at least 2
# zstyle ':completion:*' menu select=2
# compsys initialization
autoload -U compinit
compinit
# autoload -U compinit && compinit
# autoload -U bashcompinit && bashcompinit
```
2. Run `exec zsh` to apply changes
3. The completion requires *AIRFLOW_HOME* is set
4. The completion is based on a cache file which is called `.airflow_completion`. This file is put in *AIRFLOW_HOME* folder.
For the first time running airflow_completion, run `airflow_completion update_full` to build cache file. Then it's okay to use. 
5. For any channges to dags, run `airflow_completion update_dag <dag_name>` to update dag when it has more tasks or changes task names.
To delete a dag out of cache file, run `airflow_completion delete_dag <dag_name>` to delete.
