COMPLETION_FILE="$AIRFLOW_HOME/.airflow_completion"

update_full_airflow_completion(){
	rm $COMPLETION_FILE 
	list_dags=$(airflow list_dags; echo x)
	lines=("${(f)list_dags%x}")
	for dag in ${lines[@]:5} 
	do 
		echo "Finding task for '$dag'"
		list_tasks=$(airflow list_tasks $dag; echo x)
		task_lines=("${(f)list_tasks%x}")
		tasks="${task_lines[@]:2}"
		echo "\tFound: $tasks"
		echo "$dag $tasks" >> $COMPLETION_FILE
	done
}

update_airflow_dag_completion() {
        dag_name=${1}
	list_dags=$(airflow list_dags | grep "$dag_name"; echo x)
	lines=("${(f)list_dags%x}")
	echo "Dags to update: $lines"
	for dag in ${lines} 
	do 
		echo "Finding task for '$dag'"
		list_tasks=$(airflow list_tasks $dag; echo x)
		task_lines=("${(f)list_tasks%x}")
		tasks="${task_lines[@]:2}"
		echo "\tFound: $tasks"
		# TODO: check if we found real tasks, or dags does not exist
		if [[ -f $COMPLETION_FILE ]] && ( grep -q "^$dag " "$COMPLETION_FILE" ); then
		    sed -i '' -e "s/^$dag .*/$dag $tasks/" $COMPLETION_FILE
		else
		    echo $dag $tasks >> $COMPLETION_FILE
		fi
	done
}

delete_dag_from_completion() {
        dag=${1}
	list_dags=$(airflow list_dags | grep "$dag"; echo x)
	lines=("${(f)list_dags%x}")
	echo "Dags to delete: $lines"
	if [[ -f $COMPLETION_FILE ]] && ( grep -q "^$dag " "$COMPLETION_FILE" ); then
		sed -i '' -e "/^$dag.*/d" "$COMPLETION_FILE"
	fi
}
