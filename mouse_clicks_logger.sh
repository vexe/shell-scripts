#!/bin/bash

# our script takes one arg which could be either (currently): -log, -process, -stop
# -log starts logging, dumping output from xinput to a mouse.log file.
# -process will process the log file and get the actual number of clicks.
# -stop will stop logging (this should be done before -process, because as long as you're dumping stuff to the file, 
#  you won't be able to access its contents, its being used, if you do a du -sh on it, it will return 0bytes size)

# here we go, catching the arg
arg="$1";

# we're gonna put the log file in a .log dir in $HOME
test -d $HOME/.log
if [ $? -ne 0 ]; then
	mkdir $HOME/.log
fi

# getting in our log dir so that we don't have to re-type the whole path over and over again.
cd $HOME/.log

# use your own mouse -_-
mouse="SynPS/2 Synaptics TouchPad"

# using case branching :)
case $arg in

	# don't forget the '&' to run it in the background (daemonize it) I'm not gonna do it here, you do it when you run the script.
	# I didn't include the 2nd mouse button (middle click), because I have it disabled :) (annoying 2nd Linux clipboard)
	# we'll use nohup as well, so that we can safely close the terminal we ran the script from safely, not worrying about the process
	# dying, cuz, postfixing the thing with '&' isn't enough, it's true if you 'close' the terminal it will remain there runnnig, 
	# but not if you KILL the terminal (with a stronger signal, which is what my Win+Q keybinding does in awesome window manager)
	# PLEASE note that the below pattern of egrep is so sensetive, you might wanna check what xinput test mouse_name gives you first
	# before you attempt this, it could be 'mouse press' or 'mouse button' instead of 'button press' or one space instead of 3, etc.

	"-log" )		nohup unbuffer xinput test "$mouse" | unbuffer -p egrep "button press   1|button press   3" > mouseclicks.log &
					;;
	"-stop" ) 		pkill xinput
					;;
	"-process" )	n_clicks=$(wc -l mouseclicks.log | cut -d\  -f1)
					# let's make it pretty, some time/date formatting... :)
					uptime=$(uptime | cut -d\, -f1);
					report="$n_clicks mouse clicks in total @ $(date) Since: $uptime"
					echo "$report" >> mouseclicks.report
esac

exit 0;
