#Paulie's Homestyle Fresh-Caught Pushdown Automaton
This bash script reads a filepath from the user to a state list.
- The state list must have a state called 0, this being the initial state of the machine.
- Valid instructions for the machine are the following:
	- push value
		pushes "value" onto the stack
	- pop (value)
		pops "value" off of the stack, or pops off the top of the stack if run w/o argument
	- goto newstate
		set "newstate" to the next state
	- halt
		end the program
