#!/bin/bash

application_dir=/tmp/hadoop-abhishek/nm-local-dir/usercache/abhishek/appcache
namenode_ip="0.0.0.0"
application_url="http://$namenode_ip:8088/ws/v1/cluster/apps"
terminal_states=("FINISHED" "KILLED" "FAILED")

echo "Application URL : $application_url"

check_exception_based_deletion () {
        application_exception=$(echo $2 | cut -d'"'  -f 6)
        return $([ "$1" == "exception" -a "$application_exception" == "NotFoundException" ] && echo 1 || echo 0)
}


check_delete_resources() {
        check_exception_based_deletion $1 $2
        should_delete=$?
        if [ $should_delete == 1 ];
        then
                return 1
        else
                for t_state in "${terminal_states[@]}"
                do
                        if [ "$t_state" == "$1" ]; then
                                should_delete=1
                        fi
                done
        fi
        return $should_delete
}


while true
do
	cd $application_dir
	is_directory_empty=$([ "$(ls -A .)" ] && echo "false" || echo "true")
	
	if [ "$is_directory_empty" == "false" ]; then
		for application in *
		do
			echo "Checking status for application: $application"
			output=$(curl "$application_url/$application/state")

			is_delete_ready=false

			# get state from output
			application_state=$(echo $output | cut -d'"'  -f 4)
			check_delete_resources $application_state $output
			is_delete_ready=$?

			if [ $is_delete_ready == 1 ]; 
			then
				echo "Application $application is in terminal state - $application_state . Removing the temporary resources"
				rm -rf "$application_dir/$application"
			else
				echo "Application $application is in $application_state state. Hence, not terminating"
			fi
		done
	fi
	sleep 120
done

