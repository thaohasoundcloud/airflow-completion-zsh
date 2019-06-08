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
        dag=${1}
        echo "Finding task for $dag"
        list_tasks=$(airflow list_tasks $dag; echo x)
        task_lines=("${(f)list_tasks%x}")
        tasks="${task_lines[@]:2}"
        echo "\tFound: $tasks"
        if [[ ( -f $COMPLETION_FILE) && $("grep -q "^$dag " $COMPLETION_FILE") ]]; then
            $("sed -i '' -e "s/^$1.*/$dag $tasks/" $COMPLETION_FILE")
        else
            echo $dag $tasks >> $COMPLETION_FILE
        fi
}

