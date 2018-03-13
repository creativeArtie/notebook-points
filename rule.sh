#!/bin/bash

source common.sh

function mainMenu {
	half=$(tput cols)
	half=$(expr ${half} / 2)
	printf "%-${half}s%-${half}s\n" "${1}" "${2}"
}

page=0

while [ ${page} != -1 ];do
	redrawAll
	case $page in
		0)
			printCenter ${min}             "Help Menu"
			printCenter $(expr ${min} + 1) "─────────"
			echo " Help Page (You can access them in any help page)."
#                          1         2         3         4         5         6         7         8
#                 12345678901234567890123456789012345678901234567890123456789012345678901234567890
			mainMenu "  0. This page"       "  4. Todo Items Rules"
			mainMenu "  1. Notebook Format" "  5. Todo Item Types"
			mainMenu "  2. Scoring Rules      " "  6.   Grateful Items Rules"
			mainMenu "  3. To Do Scores Table " "  ANY. Exit to main"
			echo 
			echo 
			;;
		1)
			printCenter ${min}             "1. Notebook Format"
			printCenter $(expr ${min} + 1) "──────────────────"
			echo "  ❏  Notebook is small enough to fit on a single hand."
			echo "  ❏  Each page of the book should have 13 lines with a header"
			echo "  ❏  Header has the journal date."
			echo "  ❏  Line 1 - 5   are for to do items to be done on that day"
			echo "  ❏  Line 6 - 9   are for overflow to do items or grateful items."
			echo "  ❏  Line 10 - 13 are for yesterday grateful items"
			echo "  ❏  Each line represents one to do item or grateful item."
			;;
		2)
		
			printCenter ${min}             "2. Scoring Rules"
			printCenter $(expr ${min} + 1) "────────────────"
			echo " Scoring system (see also Page #3 and Page #5): "
			echo "  1. If any required item fail:        ⟶   " $(tput setaf 1)"-1"$(tput setaf 9)
			echo "  2. If (1) passed, for each optional: ⟶   " $(tput setaf 2)"+1"$(tput setaf 9)
			echo "  3. Add the milestone points:"
			echo "     ❏  every 3 month past             ⟶   " $(tput setaf 2)"+1"$(tput setaf 9)
			echo "     ❏  every 50 points past           ⟶   " $(tput setaf 2)"+1"$(tput setaf 9)
			echo "     ❏  every 100 points past          ⟶   " $(tput setaf 2)"+1"$(tput setaf 9)
			;;
		3) 
			printCenter ${min}             "3. To Do Items Rules"
			printCenter $(expr ${min} + 1) "────────────────────"
			echo "  ❏  are written with a concrete vision and completion is base on that"
			echo "  ❏  cannot be crossed out 2 days after the scheduled date"
			echo "  ❏  can either be a daily task or repeated task"
			echo " Scoring: "
			echo "  ❏  (REQUIRED) 5 item daily with over ½ complete (see next page)"
			echo "  ❏  (OPTIONAL) $(tput setaf 2)+1$(tput setaf 9) for each extra (see next page)"
			echo "  ❏  (OPTIONAL) $(tput setaf 2)+1$(tput setaf 9) complete all items"
			;;
		4)printCenter ${min}               "4. To Do Scores Table"
			printCenter $(expr ${min} + 1) "─────────────────────"
			echo " Number of item to number require and number exta."
			echo "  ❏  5 items ⟶   3 required, 2 extras"
			echo "  ❏  6 items ⟶   4 required, 2 extras"
			echo "  ❏  7 items ⟶   4 required, 3 extras"
			echo "  ❏  8 items ⟶   5 required, 3 extras"
			echo "  ❏  9 items ⟶   5 required, 4 extras"
			echo 
			;;
		5)
			printCenter ${min}             "5. Todo Items Types"
			printCenter $(expr ${min} + 1) "────────────────────"
			echo " Daily Tasks are:"
			echo "  ❏  written the day before or scheduled with a set time"
			echo "  ❏  replaceable with similar item the same purpose"
			echo " Repeated Tasks are:"
			echo "  ❏  written down / reviewed a few days before 1st and 15th of each month"
			echo "  ❏  filled in for half a month at a time"
			echo "  ❏  changable if its too hard, but needs strong reason"
			;;
		6)
			printCenter ${min}             "6. Grateful Items Rules"
			printCenter $(expr ${min} + 1) "───────────────────────"
			echo " Grateful Items: "
			echo "  ❏  can be anything"
			echo "  ❏  can not be changed or remove after written"
			echo " Scoring: "
			echo "  ❏  (REQUIRED) 3 grateful item daily"
			echo "  ❏  (OPTIONAL) $(tput setaf 2)+1$(tput setaf 9) for each item after 3ʳᵈ item."
			echo 
			;;
		*)
			exit
	esac
	read -n1 -p "Your Choice: [0 - 6, ANY] " page
done