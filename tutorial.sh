SHELL BASICS from Metalx1000:

Lesson 1:
1- for printing: "echo 'something'"
2- for halting execution: "sleep n" n: secs.
3- before you run your script, make it executable: "chmod +x script.sh"
4- to read from the user (prompt for input): "read var"
5- to derefrence a variable, use the '$' sign before the variable name.
6- to redirect the output to a file, use the '>' like in "echo hello > tmp.txt" this will overwrite everything with 'hello'. To append the output to what was previously in the file, use the '>>' like in: "echo 'yo dawg' >> tmp.txt" 

_____________________________________
Lesson 2:

Boring stuff, nothing new.

_____________________________________
Lesson 3:

<grep and cut commands>
1- grep [OPTIONS] [PATTERN] [FILE(S)]
	searches for [PATTERN] within [FILE(S)], if not files are specified, it searches the 	
	standard input.

Most used switches:
-i: case in-sensitive.
-A: number of lines to grep, after the found row.
-r: recursive.
-v: invert serach.

2- cut [OPTIONS] [FILE(S)]
	Removes sections of each lines from [FILE(S)]
	If [FILE(S)] is/are not specified, it takes input from the standard input.

Most used switches:
-d: delimiter.
-f: number of field.	

Example1: let\'s say we have a file, a simple comma-separated db:
vexe, 20, sysprog
sherry, 21, webdev
nic, 26, artist
nika, 22, webdev
zix, 22, sysprog

let\'s say we just, want to print out only the webdevs\' names:
"cat db | grep webdev | cut -d\, -f1" OR "grep webdev db | cut -d\, -f1"
output: 
sherry
nika
if we wanna wanna know their ages as well: "grep webdev db | cut -d\, -f1,2"
sherry, 21
nika, 22

Example2: we wrote some message, but we don\'t know where we saved it, but we do know what we wrote in it (some of the contents of that message), for example, the word 'programming'
We also know, that it\'s possibilly located in home, so we do (assuming that pwd=/home/vexe):
vexe~$ grep -r 'programming' .
-r: recursive.
.: start searching in the current directory. if you forget this, it won\'t work properly.

NOTE: it\'s SO FRECKIN case sensitive. The previous command wouldn't work if we did:
"grep webdev | cut -d\, -f1, 2" #NO SPACES BETWEEN THE FIELDS.

_____________________________________
Lesson 4:

<Implementation of grep|cut using lynx (text-based webbrowser)>

The combonation of lynx, grep|cut will let you do a whole lot of cool thing.
One of them is extracting links from within pages. For example:
http://ccmixter.org/view/media/remix
This page has some songs within it, we're gonna extract the link to each song, and do something with it, like play it with mplayer.
The parameters that we're gonna be passing to lynx:
	-dump: prints out the formatted text of a page/directory.
	-source: works like -dump, but for the HREFs of the page.
	Example:
	~/temp$ ls
	~/temp$ gdm songs
	~/temp$ lynx -dump .
        drwx------   69 vexe     users       4096 Mar  4 22:45 [1]../
    	-rw-r--r--    1 vexe     users      17326 Feb 28 13:00 [2]gdm
        -rw-r--r--    1 vexe     users          0 Mar  4 22:41 [3]songs	
	References
	1. file://localhost/home/vexe
	2. file://localhost/home/vexe/temp/gdm
	3. file://localhost/home/vexe/temp/songs

But for our page, -dump isn't any good for us, we'll use -source. So:
"lynx -source 'http://ccmixter.org/view/media/remix'"
But that's a lot of source, let's reduce it:
"lynx -source 'http://ccmixter.org/view/media/remix' | grep mp3"
Now, we'll cut only the substrings/sections that have the HREFs for our mp3s:
"lynx -source 'http://ccmixter.org/view/media/remix' | grep mp3 | cut -d\' -f4"
And you'll see a list of the mp3s in the page, copy/paste one of the links to mplayer, and enjoy the music:
"mplayer 'http://ccmixter.org/content/texasradiofish/texasradiofish_-_If_I.mp3'"

Next lesson we'll see how we could play them all in a loop :)

_____________________________________
Lesson 5:





Lesson 7: head, tail and more/less:

head <file>: outputs the first 10 lines (by default) of the file.
tail <file>: does the same, but for the last tines. 
more/less <file>: this will let you view the file page by page, scroll through it, page up/down, search down with '/', up with '?', etc.

All of the above could be piped, like: "dmesg | tail" 

you could specify the number of lines shown in head/tail with the -n switch.


_____________________________________
Lesson 8: figlet

figlet is a very nice tool for ascii art kinda output, just figlet "V3X3"
__    __ ____ __  _ ____
\ \   / /___ /\ \/ /___ / 
 \ \ / /  |_ \ \  /  |_ \ 
  \ V /  ___) |/  \ ___) |
   \_/  |____//_/\_\____/ 


Here's a nice clock script from: http://www.linuxjournal.com/content/tech-tip-using-figlet-spice-your-scripts

while [ 1 ];do
	clear;
	date +%r | figlet;
	sleep 1;
done;

  ___  ____   _  ___    _  ___       _    __  __ 
 / _ \| ___|_/ |/ _ \ _/ |/ _ \     / \  |  \/  |
| | | |___ (_) | (_) (_) | | | |   / _ \ | |\/| |
| |_| |___) || |\__, |_| | |_| |  / ___ \| |  | |
 \___/|____(_)_|  /_/(_)_|\___/  /_/   \_\_|  |_|
                                                 

_____________________________________
Lesson 9: Getting a colored terminal, like when listing files.

Just install a package called 'coreutils' and that should do it.
in your .bashrc make an alias for ls and the stuff you want: alias ls='ls --color=auto'
And done!


_____________________________________
Lesson 10: difference between echo $var and echo ${var}

For example: 
$var='I love the ';

# now if you do: echo $varterminal; you'll get nothing right? BUT:
echo ${var}terminal;
>> I love the terminal!


_____________________________________
Lesson 11: Simple terminal controls:

Extensive list: 
http://www.aboutlinux.info/2005/08/bash-shell-shortcuts.html

-Ctrl+e: end of line.
-Ctrl+a: beginning of line.
-Ctrl+u: delete/(cut?) everything behind the cursor.
-Ctrl+r: browse bash history.
-Ctrl+c: terminate a command.
-Ctrl+z: stop a command temporarily, useful when you wanna put a process in the background.
-Ctrl+l: 'clear's the screen.
-Ctrl+xx: jumps between bog (beginning of file) and the current cursor position.
-Ctrl+d: delete from under the cursor.

-Alt+w: move a word forward.
-Alt+b: same, but backwards.
-Atl+d: delete a word forward (ahead of the cursor)
-Alt+backspace: same, but backwards (like Ctrl+backspace in some GUI editors)
Alt+t: move the words that are between cursor around.
 
_____________________________________
Lesson 12: the 'tr' command:

This is actually pretty handy. It transforms stuff. Check out tr --help for a quick list of what it could do. Examples:

-Convert all lower/upper to upper/lower case characters:
echo 'This Is Pretty Cool' | tr '[:lower:]' '[:upper:]'
output: "THIS IS PRETTY COOL"

-Replace all spaces, with an underscore:
echo 'I hate spaces' | tr '[:space:]' '_'
outpuT: "I_hate_spaces_" # don't ask me about the last underscore, I don't know! I just got it in my machine :3

tolu (to lower/upper) script:

  1 #!/bin/bash
  2 
  3 arg=$1;
  4 text=$2;
  5 usage="Usage: tolu [OPTIONS] [INPUT_TEXT]\nOPTIONS: -u to upper -l to lower."
  6 if [[ "$arg" = "" || ("$arg" != "" && "$text" = "") ]];then
  7         echo -e $usage;
  8         exit 1;
  9 fi;
 10 if [[ "$arg" = "-l" ]];then
 11         echo $2 | tr '[:upper:]' '[:lower:]';
 12 elif [[ "$arg" = "-u" ]];then
 13         echo $2 | tr '[:lower:]' '[:upper:]';
 14 else
 15         echo -e "$usage";
 16 fi;

NOTE: converting from/to lower/upper case, could be done in another way:
echo "Convert Me" | tr 'A-Z' 'a-z'
  
_____________________________________
Lesson 13: cowsay and fortune

Those are probably the coolest thing ever, cowsay prints you a cow, that says stuff. 
so you do 'cowsay "something..."' 
do a cowsay -l for a list of what shapes are available. 
change the shape with -f. like: cowsay -f beavis.zen "Hey how's it goin? HE/HE"

fortune prints random quotes everytime you run it, you could mix it with cowsay and get a quoter-beavis:
"fortune | cowsay -f beavis.zen"  

_____________________________________
Lesson 14: for loop implementaion, stdout/stderr redirection with network scanning the LAN.

REDIRECTING:
From: http://stackoverflow.com/questions/876239/bash-redirect-and-append-both-stdout-and-stderr
To redirect stdout in bash, overwriting file
cmd > file.txt
To redirect stdout in bash, appending to file
cmd >> file.txt
To redirect both stdout and stderr, overwriting
cmd &> file.txt
To redirect both, appending: 
cmd >> file.txt 2>&1

About the ping command: 
-cn: number of pings, n: integer.
-wn: timeout, n: seconds.
It could be used within a conditional statement, where if it succeeds, the condition is met, else not.

Everything about the for loop: http://www.cyberciti.biz/faq/bash-for-loop/

our script: 

  1 #!/bin/bash
  2 
  3 # This will scan all the local computers in the local network, if a computer is up, it'll say so.
  4 for ip in 192.168.100.{1..254}; do
  5         if ping -c1 -w1 $ip &> /dev/null; then
  6                 echo "$ip is up."
  7         else
  8                 echo "$ip is down."
  9         fi;
 10 done;

_____________________________________
Lesson 14: Using find

Syntax: find [WHERE_TO_LOOK] [PATTERN] [WHAT_TO_LOOK_FOR]
find is used to search for files/directories with a certain pattern in a certain place.

example: find / -iname *savage2* 

This will search starting from root going down, finding anything that contains the word 'savage2' in it, whether it\'s a file or directory. 
-iname stands for case in-sensitive. (Savage=savage=SAVAGE)
-name is the oposite.
-what will the previous command give you? NOTHING! ALWAYS REMEMBER TO RUN FIND AS ROOT IF YOU\'RE PERFORMING EXTENSIVE SEARCHES IN ROOT-PREVILIAGES AREAS. Use sudo.

you could search by size, finding files smaller/bigger than a specific size:
find -size +1000M
This will find everything that has a size of 1GB or above.
If you don\'t specify where to look, the search will deafult to your current working directory.

finding all tarballs that is of lower space than 500MBs:
sudo find / -iname *.tar* -size -500M


ALWAYS RUN IT AS ROOT IF YOU ARE PERFORMING EXTENSIVE SEARCHES LIKE THE ONE ABOVE.


_____________________________________
Lesson 15: regex - Regular expressions

Mainly, they\'re used to search for stuff, you use them in your searches patterns to make the results more useful and the search effective.

- For example, say we have this, word.txt file:

<<
vexe is my nick name


Vexe is my nick Name
VeXe: call me on 1234
1234 is my number

vexe

it begins with 12 and ends with 34
yo yawl heard me, it\'s vexe
>>

- output the lines that has the word vexe in them: "grep vexe words" that will give us the first and last lines.
- what is we wanted all the vexes in the file? "grep -i vexe words" -i for case-insensitive. 
- what if we want, only the vexes that start with a lower/upper case v, and then just 'exe': "grep [vV]exe words"
- only the lines that starts with v/Vexe: "grep ^[vV]exe words"
- lines containing number: "grep [0-9] words" will show 4 lines. 
- lines that end with 3 digits or more: "grep [0-9][0-9]0-9]$ words" will only print out the 3rd line. 
- print out the lines that contains ONLY 'vexe': "grep ^vexe$ words"
- print out the whitespace-character lines: "grep ^$ words"
- to make that useful, we invert the search: "grep -v ^$ words" this will print out the whole file, but without empty lines.

_____________________________________
Lesson 16: String manipulation

- get a string length: 
	${#myString} # where myString should be a variable.
	expr length myString; # this time, it could be a literal string.
	echo $myString/'something' | wc -c 

- getting a substring of a string, at a specific location, and length.
	str='1ToThrFourFiveeSSIIXX';
	echo ${str:0}; 		# output: the whole string.
	echo ${str:0:1} 	# output: 1.
	echo ${str:3:3}		# output: Thr.
	echo ${str:6:`expr length 'XXXX'`}

_____________________________________
Lesson 17: Fun with Gmail

We\'ll make a script that will let us execute commands in our computer, via a message we get from our Gmail.
This is very useful in cases where you wanna help a friend fix some problems, and you can\'t ssh to him, or you\'re
far from home, and wanna backup your computer, and upload the backup to dropbox! Yes, you can do that, just send the
proper commands, and boom!

There is a service in Gmail, that gives you a summary of what\'s new in your inbox.
it\'s mail.google.com/mail/feed/atom
We\'re gonna use wget to download the source of that page, and authenticate with our user/pass.

msg=`"wget -q --secure-protocol=TLSv1\
		--user=xarxoohx --password=123xarxoohx321\
		 https://mail.google.com/mail/feed/atom -O -"`

-q: 					# quite, no output. 
--secure-protocol: 		# the protocol used for connecting. The one we used is for Gmail.
--user					# user name for login.
--password				# his password.
-O -: 					# by default, the output will get redirected to a file called 'atom' in the current directory.
						# we used those args to re-direct it to the screen.

So we then send ourselve a message, with the format of: "COMMANDS:com1;com2 arg1;com3 arg1 arg2, etc."

We then process the msg var (which we could throw to a file), to grep the commands we want: "grep COMMANDS $msg"
We then use cut, and maybe awk, to extract the commands from the html tags.

Here is something helpful for cutting, and using words as a delimiter: 
str='/some/useless/crap/root/yaw/dawg/what/up'
echo ${str%root*};  # output: '/some/useless/crap/'
echo ${str#*root}; 	# output: '/yaw/dawg/what/up'

After fully extracting the commands, we could put them in a file, and `cat file` or something like that.
The file itself might need some extra processing, depeding on the way the commands are sent.
