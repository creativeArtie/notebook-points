#!/bin/bash

function printCenter {
	local row input col
	row="$1"
	input="$2"
	col=$(( $(tput cols) / 2 - ${#input} / 2 ))
	tput cup ${row} ${col}
	echo "${input}"
}

function booleanInput {
	local ans promp
	promp="$1"
	read -n1 -p "${promp} [Y/n]: " ans
	
	if ! [ -z $ans ]; then
		if [ $ans = 'y' -o $ans = 'Y' ] ;then
			echo 1
		else
			echo 0
		fi
	else
		echo 1
	fi
}

function redrawAll {
	# add a blue blackground and bold text
	tput bold
	tput setab 4
	clear

	# Add title
	printCenter 1 "Notebook Point"
	printCenter 2 "▀▀▀▀▀▀▀▀▀▀▀▀▀▀"

	#clean up, reset format for all other text
	tput cup 4 0
	echo -n $(tput sgr0) $(tput setab 9)
	tput ed

	# Prints game overview
	#                         1         2         3         4         5         6
	#                123456789012345678901234567890123456789012345678901234567890
	#                abcdefghijklmnopqrstuvwxyz01233210zyxwuvtsrqponmlkjihgfedcba
	printCenter 4  '╭────────────────────────────────────────────────────────────╮'
	printCenter 5  '│                      About & Overview                      │'
	printCenter 6  '│                      ════════════════                      │'
	printCenter 7  '│Overview: Gamification of a daily to do list and gratitude  │'
	printCenter 8  '│          journal                                           │'
	printCenter 9  '│Requirement: a handheld notebook with each page contains    │'
	printCenter 10 '│             12 lines                                       │'
	printCenter 11 '│Outcome: ⒈ Write ≥ 3 things you are grateful every day.     │'
	printCenter 12 '│         ⒉ Write ≥ 5 things to do every day & complete ≥ ½. │'
	printCenter 13 '╰────────────────────────────────────────────────────────────╯'

	#Setup for main menu loop
	s=${min}
	working=1
	error=""
}

min=14