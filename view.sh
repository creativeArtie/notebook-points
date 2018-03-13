#!/bin/bash

# Usage: awk -f view.awk data.csv | bash view.sh

source common.sh

# Print the table heading
#              1         2         3         4         5         6         7         8
#     12345678901234567890123456789012345678901234567890123456789012345678901234567890
echo "┌────────────┬────────────────────┬─────────────────┬─────────────┐"
echo "│  Notebook  │      Requires      │    Optionals    │  Milestone  ├────────────┐"
echo "│   Logged   │  ≥5  │  ≥½  │  ≥3  │   Todos   │Grat.│  =3  │5, 100│   Sorces   │"
echo "│    Date    │To Dos│ Done │ Grat.│ > 5 │ All │ > 3 │Months│Points│Day│ Totals │"
echo "┝━━━━━━━━━━━━┿━━━━━━┿━━━━━━┿━━━━━━┿━━━━━┿━━━━━┿━━━━━┿━━━━━━┿━━━━━━┿━━━┿━━━━━━━━┥"
#                    FAIL   FAIL   FAIL  12345 12345 12345               123 12345678
i=0
for x in $(cat ); do
	case $i in
	0) # column 0 = date
	
		echo -n "│"$(date -d "${x}" +"%b %d, %Y")"│ "
		;;
	[1-3]) # column 1 - 3: required item 
	
		# Print FAIL / PASS
		if [ ${x} = "FAIL" ]; then
			# Red text for fails
			tput setaf 1
			echo -n ${x}
			tput setaf 9
			echo -n " │ "
		else
			echo -n "${x} │ "
		fi
		;;
	[4-6]) # column 4 - 6: optional items
		
		#start spaces, column 4 starts with one space from [1-3]) part
		if [ ${i} = 4 ]; then
			
			echo -n "   "
		else
			echo -n "    "
		fi
		
		# Print number 
		if [ ${x} -gt 0 ]; then
			# Green text for numbers > 0
			tput setaf 2
			printf '%1d' ${x}
			tput setaf 9
			echo -n "│"
		else
			echo -n "${x}│"
		fi
		
		# Add spaceing milesetones 
		if [ ${i} = 6 ]; then
			echo -n "  "
		fi
		;;
	[7-8]) # column 7 - 8: optional items
	
		# Show the milestone points
		if [ ${x} = "00" ]; then
			echo -n "${x}  │"
		else
			# Green text for ${x} > 0
			tput setaf 2
			printf "${x}"
			tput setaf 9
			echo -n "  │"
		fi
		
		# Space only for milestone points
		if [ ${i} != "8" ]; then
			echo -n "  "
		fi
		;;
	[9]) # day score
	
		# Show score to be added
		if [ ${x} = '-1' ]; then
			# red text for -1
			tput setaf 1
			printf '%3d' ${x}
			tput setaf 9
			echo -n "│"
		else 
			printf "%3d│" "${x}"
		fi
		;;
	*) # Running total
		
		# Red text for negative
		if [ $x -lt 0 ]; then
			tput setaf 1
		fi
		
		# Show the score
		if [ ${#x} -gt 8 ]; then
			print "%8e" ${x}
		else
			printf "%8d" ${x}
		fi
		
		# Clear format if set
		tput setaf 9
		echo "│"
	esac
	i=$(( (i + 1) % 11 ))
done

echo "└────────────┴──────┴──────┴──────┴─────┴─────┴─────┴──────┴──────┴───┴────────┘"