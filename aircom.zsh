#!/bin/zsh
COMPLETION_FILE="$AIRFLOW_HOME/.airflow_completion"
_airflow_completion_find_dag_and_sub_dags(){
	list_dags=$(airflow list_dags | grep -w "$1"; echo x)
	lines=("${(f)list_dags%x}")
        echo $lines
}

_airflow_completion_find_tasks(){
        list_tasks=$(airflow list_tasks $1; echo x)
        task_lines=("${(f)list_tasks%x}")
        tasks="${task_lines[@]:2}"
        echo $tasks
}

_airflow_completion_update_full(){
	rm $COMPLETION_FILE 
	list_dags=$(airflow list_dags; echo x)
	lines=("${(f)list_dags%x}")

	for dag in ${lines[@]:5} 
	do 
            echo "Finding task for '$dag'"
            tasks=(`_airflow_completion_find_tasks $dag`)
            echo "\tFound: $tasks\n"
            echo "$dag $tasks" >> $COMPLETION_FILE
	done
}

_airflow_completion_update_dag() {
        dag=${1}
        related_dags=(`_airflow_completion_find_dag_and_sub_dags $dag`)

        if [ ! -z "$related_dags" ]; then
          {
              echo "Dags to update: $related_dags\n"
              sed -i '' -E "/^${dag}[ .].*/d" "$COMPLETION_FILE"

              for dag in ${related_dags} 
              do 
                  echo "Finding task for '$dag'"
                  tasks=(`_airflow_completion_find_tasks $dag`)
                  echo "\tFound: $tasks\n"

                  dag_escape_dot=$(echo -e "${dag/./\.}")
                  if [[ -f $COMPLETION_FILE ]] && ( grep -q "^$dag_escape_dot " "$COMPLETION_FILE" ); then
                        sed -i '' -e "s/^$dag_escape_dot .*/$dag $tasks/" $COMPLETION_FILE
                  else
                        echo $dag $tasks >> $COMPLETION_FILE
                  fi
              done
          }
        else
            echo "Dag '$dag' does not exist in database anymore. Use 'delete_dag' to remove from cache."
        fi
}

_airflow_completion_delete_dag() {
        dag=${1}
        dag_escape_dot=$(echo -e "${dag/./\.}")
        related_dags=(`_airflow_completion_find_dag_and_sub_dags $dag`)

        echo "Dags to delete: ${related_dags:-$dag}"

	if [[ -f $COMPLETION_FILE ]] && ( grep -q "^$dag_escape_dot " "$COMPLETION_FILE" ); then
              sed -i '' -E "/^${dag_escape_dot}[ .].*/d" "$COMPLETION_FILE"
	fi
}

aircom() {
	case "$1" in 
		(update_full)
			(_airflow_completion_update_full)
		;;
		(update_dag)
			(_airflow_completion_update_dag $2)
		;;
		(delete_dag)
			(_airflow_completion_delete_dag $2)
		;;
	esac
	return 1
}

