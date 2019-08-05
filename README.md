# Airflow auto-completion
This repo builds auto-completion scripts for **Apache Airflow** command line tool in **z-shell**.

The completion is based on a cache file named **`.airflow_completion`**, which stores all dag and task names. This file is put in **AIRFLOW_HOME** folder. 
To build `.airflow_completion` cache file, we use **`aircom`** command.

### Set up
1. Git clone this repo.
2. Put below settings in .zshrc
```bash
# COMPLETION SETTINGS
# add custom completion scripts
source "<your_repo_folder>/aircom.zsh"
fpath=(<your_repo_folder> $fpath)

autoload -U compinit
compinit
```
3. Run `exec zsh` to apply changes.
4. Spin up your airflow virtual environment. The completion script requires *AIRFLOW_HOME* is set.
5. Run `aircom update_full`: build cache file `.airflow_completion` in Airflow home folder.

It's okay to use now. For example, type `airflow test<TAB>`, a list of dags should be shown. 

### Commands
- `aircom update_dag <dag_name>`: add/update dag info in cache file when new dag is created, or the dag has more tasks/sub-dags or changes task/subdag names.
- `aircom delete_dag <dag_name>` to delete a dag out of cache file.
- `aircom update_full`: rebuild all dags in cache file.

**NOTE**: command `aircom` do have auto-complete, so you can use `TAB`s to interact.
