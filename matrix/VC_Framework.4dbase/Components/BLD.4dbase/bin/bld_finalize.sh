# /bin/bash
# Final step when building component, called by build method.
# Do not execute this script manually, it is called by the component.

# Argument list:
# 1 - 4D application process ID
# 2 - Component name
# 3 - Component folder

# Global vars
pidOf4D_l=$1
component_name=$2
component_folder=$3


# Function declarations
bld_usage(){
	echo "Do not execute this script manually, it is called by $component_name"
	exit 1
}


pause(){
   read -p 'Press [Enter] key to continue...'
}


bld_copyFiles(){
	component_dir="./$component_folder/$component_name.4dbase"
	source_dir="./matrix/$component_name.4dbase"
		
	# Files we need:
	#   -4DB
	#   -4DINDY
	
	echo 'Copying structure file...'
	cp "$source_dir/$component_name.4DB" "$component_dir/$component_name.4DB"
	
	echo 'Copying structure index file...'
	cp "$source_dir/$component_name.4DIndy" "$component_dir/$component_name.4DIndy"
}


bld_start(){
	numTries_l='.'
	is4DRunning_l=`ps -p $pidOf4D_l | wc -l`
	
	# Wait for 4D to quit.
	while [ $is4DRunning_l != 1 ]
	do
		clear
		
		# Let the user know what's happening, and how many times.
		echo "Waiting for 4D to quit$numTries_l"
		
		# Delay for 1 second
		sleep 1
		
		# Check to see if 4D is running.
		# Returns 2 if found, 1 if not.
		is4DRunning_l=`ps -p $pidOf4D_l | wc -l`
		
		numTries_l="$numTries_l."
		
		# If 4D is still running, loop again.
	done
		
	echo '4D has quit!'
	
	bld_copyFiles
}


# Begin actual script.

# Check for Argument; if not passed script was probably called manually.
if [ ! $# == 3 ]; then
	bld_usage
else
	bld_start
	echo 'Build complete!'

	exit 0
fi

