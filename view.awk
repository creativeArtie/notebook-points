#!/bin/awk

function require(test, i){
	if (test){
		ans[NR, i] = "PASS"
	} else {
		ans[NR, i] = "FAIL"
		fail=1
		subtotal = -1
	}
}

function optional(input, i){
	if (fail == 1){
		ans[NR, i] = 0
	} else {
		if (input >= 0){
			ans[NR, i] = int(input)
			subtotal = subtotal + int(input)
		} else {
			ans[NR, i] = 0
		}
	}
}

BEGIN{
  CROSS_DATE=" 2 day"
  MILESTONE_LOWER = 5
  MILESTONE_UPPER = 10
	record = 0
	grandTotal = 0
	milestoneLower = 5
	milestoneUpper = 10
}

NR==1{  
	"date -d '" $1 " ' +%s" | getline pastDate
}

{
	fail=0
	subtotal=0
	ans[NR,0]=$1
	require($2 >= 5, 1)
	require($2 / 2 < $3, 2)
	require($4 >= 3, 3)
	
	optional($3 - ($2 / 2), 4)
	optional($3 == $2, 5)
	optional($4 - 3, 6)
	
	"date -d"$1" +%s" | getline curDate
	if (curDate == pastDate){
	  ans[NR, 7] = "+1"
	  "date -d '"$1 CROSS_DATE "' +%s" | getline pastDate
	  subtotal = subtotal + 1
	} else {
	  ans[NR, 7] = "00"
	}
	
	# system("echo $(date -d '@"pastDate"') $(date -d '@"curDate"')")
	
	milestone = 0
	if (milestoneLower < grandTotal){
	  milestone = milestone + 1
	  milestoneLower = MILESTONE_LOWER + milestoneLower
	}
	if (milestoneUpper < grandTotal){
	  milestone = milestone + 1
	  milestoneUpper = MILESTONE_UPPER + milestoneUpper
	}
	if (milestone == 0){
	  ans[NR, 8] = "00"
	} else {
	  ans[NR, 8] = "+" milestone
	}
	
	ans[NR, 9] = subtotal + milestone
	
	grandTotal = grandTotal + subtotal
	ans[NR, 10] = grandTotal
}

END {
	for (i = 1; i <= NR; i++){
		for(j = 0; j <= 10; j++){
			printf ans[i,j] " "
		}
		print ""
	}
}
