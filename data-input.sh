#!/bin/bash

source ./common.sh

# Finds a number between 0 to ${2} to an answer for ${1}
# param:
#	$1 - question to answer
#	$2 - the maximum possible input
# stdout:
#	- user input and information printing
#	- output will use 2 lines and will removed before exiting the function
# return (hacked):
#	user's input
function count {
	# setup 
	local ans error running
	tput sc
	running=1
	
	while [ ${running} = 1 ]; do
		running=0 #assume success
		# Show error if found
		if [ -n "$error" ];then
			echo $error
		fi
		
		# Find the number and ...
		read -p "$1 [number/empty to exit] " ans
		re='^[0-9]+$'
		if [ -z "${ans}" ]; then
			exit
		elif ! [[ $ans =~ $re ]] ; then
			# not a number error
			error="error: \"${ans}\" is not a number or is less then 0."
			running=1
		elif [ -n "$2" ]; then
			if [[ $ans -gt "$2" ]]; then
				# out of range error
				error="error: Number (${ans}) is greater then ${2}"
				running=1
			fi
		fi
		tput rc
		tput ed
	done
	return ${ans}
}

# Print title
printCenter $(expr "${min}") "Data Input"
printCenter $(expr "${min}" + 1) "──────────"

# Setup
s=$(expr "${min}" + 2 )
tput cup ${s} 0

if [ -s data.csv ]; then 
	# track down last date enter
	startDate=$(tail -1 data.csv | cut -d ' ' -f 1)
	
	# calculate next max to do
	maxTodo=$(tail -1 data.csv | cut -d ' ' -f 4)
	maxTodo=$(expr 9 - ${maxTodo})
	isFail=0
else
	isFail=1
fi

while [ ${isFail} = 1 ]; do
	read -p "Start Date: date -d " startDate
	startDate=$(date -d "${startDate}" +%x)
	isFail=$?
	if [ ${isFail} = 0 ]; then
		date=$(date -d "${startDate}" +"%A %B %d, %Y")
		maxTodo=9
	fi
	tput cup ${s} 0
	tput el
done

moreInput=1

while [ $moreInput = 1 ]; do
	# refresh screen
	tput cup ${s} 0
	tput ed
	
	# setup and print date
	date=$(date -d "${startDate}" +"%A %B %d, %Y")
	echo "For ${date}"
	
	# ask for number of to do items.
	count "Total to do items (max: ${maxTodo}):" "${maxTodo}"
	todo=$?
	
	# ask for number of completed to do items.
	count "Total to do item (out of ${todo}) done:" "${todo}"
	complete=$?
	
	# ask for the list of grateful items
	count "Total of grateful items:" 7
	grateful=$?
	
	# Show user inputs and ask for confirmation:
	echo "Todo items: ${todo} (${complete} done)"
	echo "Grateful items: ${grateful}"
	dataCorrect=$( booleanInput "Is data input correctly?")
	
	# clear screen again
	tput cup ${s} 0
	tput ed
	
	if [ $dataCorrect = 1 ]; then
		# store data
		echo "$startDate $todo $complete $grateful" >> data.csv
		
		# go to next day
		startDate=$(date -d "${startDate} 1 day"  +%x)
		
		# change max to do items 
		maxTodo=$(expr 7 - ${grateful})
		maxTodo=$(expr 5 + ${maxTodo} )
		
		# report to user
		echo "${date} data inserted into database."
	else
		# report to user
		echo "Entered data is ignored."
	fi
	
	# As if there are more inputs
	moreInput=$( booleanInput "Has next date data?")
	
done