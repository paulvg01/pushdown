#/bin/sh

function pop {

	data=$(cat .stack | tail -n 1)
	: > .tmp
	IFS=$'\n'
	if [[ "$data" == "$1" ]] || [[ "$*" == "" ]]; then
		for line in `cat .stack | head -n -1`; do
			echo "$line" >> .tmp
		done
		: > .stack
		for line in `cat .tmp`; do
			echo "$line" >> .stack
		done
	fi

}

function push {

	echo "$1" >> .stack

}

function goto {

	: > .currentstate
	state="$1"
	regex="^$state \["
	let readline=0
	IFS=$'\n'
	for line in `cat statelist`; do
		if [[ $readline == 1 ]]; then
			if [[ "$line" == "]" ]]; then
				let readline=0
			else
				echo "$line" | sed -e 's/^\s//g' | sed -e 's/\s$//g' >> .currentstate
			fi
		elif [[ "$line" =~ $regex ]]; then
			let readline=1
		fi
	done

}

function dothing {

	commandregex="^(push|pop|goto|halt)"
	if [[ "$command" =~ $commandregex ]]; then
		eval "$command"
		clear
		cat .stack
	else
		echo "Error: '$command' is not a valid command. Halting..."
		exit
	fi

}

function dostate {

	if [[ -s .currentstate ]]; then
		IFS=$'\n'
		for command in `cat .currentstate`; do
			dothing
			if [[ ! "$command" =~ ^goto ]]; then
				sleep 1
			fi
		done
	else
		echo "Error: State '$state' is not defined. Halting..."
		exit
	fi
	cat .stack
	echo

}

function halt {

	clear
	cat .stack
	exit

}

: > .stack
goto 0
while [[ true ]]; do
	dostate
done
