#!/bin/bash 

# set -x;

# 1- str_len (str) - Returns the length of its passed arg.
function str_len() {
	echo `expr length "$1"` 2> /dev/null;
}
#-----------------

# 2- str_cat (str1, str2) - Returns the concatination of its 2 passed string args.
function str_cat(){
	echo -e "${1}""$2" 2> /dev/null;
}
#-----------------

# 3- str_sub (str, pos, nChars) - Returns a substring from its first string arg 'str', starting at 'pos', counting 'nChars' down the road.
function str_sub() { 
	str="$1";
	let pos="$2";
	let nChars=$(str_len "$1")-"$pos"; # by default, if no nChars were specified, we stop at the end.
	if [ -n "$3" ]; then
		let nChars="$3";
	fi
	echo "${str:pos:nChars}";
}
#_________________

# 4- str_contain (str, substr) - Returns true (0), if 'substr' is found within 'str', else false (1).
function str_contain()
{
	
	str="$1";
	substr="$2";
	
	# there's actually 2 ways we could go about this, the smart fancy sed way, or the usual borin' loopin' programming way.
	# 1- using sed: utilizing the fact that if sed couldn't find the 'substr' that it wants to replace in 'str', 
	# 				it would return an empty string.
	echo "$str" > /tmp/str_contain;
	does_exist=`sed -n "s/"$substr"/BUNGHOLE/p" /tmp/str_contain`; # DO NOT use single quotes with sed here, 
																  # they don't derefernce the '$' and get the value of the var.
																  # One thing worth mentioning, is that BUNGHOLE is an arbitrary value.
	if [ -n "$does_exist" ]; then
		return 0;		
	fi
	return 1;

	# 2- the average way:
	# let LEN=$(str_len "$str");
	# let len=$(str_len "$substr");
	# for ((i = 0; i < LEN; i++)); do
	# 	portion=$(str_len "$i" "$len");
	# 	if [ "$portion" = "$substr" ]; then
	# 		return 0;
	# 	fi
	# done;
	# return 1;
}
#-----------------------

# 5- str_getch (str, index) - Returns str[index].
function str_getch()
{
	str="$1";
	index=$2;
	
	# 0- string str_sub, the easy way.
	char=$(str_sub "$str" "$index" 1);

	# 1- using awk. IN PROGRESS
	# let index++;
	# char=$(echo $str | awk -F "" '{print $index}')
		
	# 2- average way.
	# if [ -z "$str" -o -z "$index" ]; then
	# 	return 1;
	# fi
	# if [ "$index" -gt $(str_len "$str") ]; then
	# 	return 1;	
	# fi
	# char="$(str_sub "$str" $index 1)";
	echo "$char";	
}
#-----------------------

# 6- str_replace (str, old, new, ALL) - Replaces 'old' with 'new' within 'str'. Pass in 'ALL' as a last arg, to replace all occurances.
function str_replace() 
{
	str="$1";
	old="$2";
	new="$3";
	str_contain "$str" "$old";
	if [ $? -eq 1 ]; then 
		return 1;
	fi;

	ALL="0";  # by default, don't replace every occurance.
	if [ "$4" = "ALL" ]; then
		ALL="1";
	fi;

	# We got 2 ways to go about this, first sed, and the average way.
   	# 1- sed: just normal find and replace.	
	temp=/tmp/STRRREPLACE;
	echo "$str" > $temp;
	if [ $ALL -eq "1" ]; then
		echo $(sed -n "s/"$old"/"$new"/gp" $temp);
	else
		echo $(sed -n "s/"$old"/"$new"/p" $temp);
	fi;
	
	# 2- 
}

# 7- str_indexof - Returns the index of the 'inst'th occurance of 'sub' in 'str'. 
# if 'inst' was 0, all instances will be returned in one string.
# if nothing's found, returns -1. Which means that this function could actually be used to check if a substr exists within a string.
function str_indexof() {
	str="$1";
	sub="$2";
	# read -p "SUB IS $sub";
	inst="$3";	
	let n_found=0;
	len=$(str_len "$sub");
	LEN=$(str_len "$str");
	pos="-1";
	
	# Basically, the idea is almost the same as str_contain, except that the sed way won't exactly fit the way we used it in str_contain.
	# So we'll go for the 2nd one.
	for (( i = 0; i < LEN; i++ )); do
		portion=$(str_sub "$str" "$i" "$len");
		# echo $portion; read -p "PRESS ENTER";
		if [ "$portion" = "$sub" ]; 
		then
			let n_found++;
			if [ "$inst" = "0" -o "$inst" = "LAST" ]; 
			then
				if [ "$n_found" -eq 1 ]; then pos=""; fi;
				pos=$(str_cat "$pos" " $i"); # make sure you include a space after/before pos/i
							   				 # so that the indices are distinguished.
			else
				if [ "$n_found" = "$inst" ]; 
				then
					echo $i;
					return 0;
				fi
			fi
		fi	
	done;

	# Not found. 
	if [ "$inst" = "LAST" ]; then
		echo $pos | awk -F " " '{print $NF}';
	else
		echo $pos;
	fi

	if [ "$pos" = "-1" ]; then
		return 1;
	fi
	return 0;
}

# 8- str_insert (str, substr, index) - Inserts 'substr' within 'str' at 'index'.
function str_insert() {
	str="$1";
	substr="$2";
	index="$3";
	LEN=$(str_len "$str");

	if [ "$index" -ge "$LEN" ]; then
		echo $(str_cat "$str" "$substr");
		return 0;
	elif [ "$index" -le 0 ]; then
		echo $(str_cat "$substr" "$str");
		return 0;
	fi

	# the idea is to loop till we stop at our index, then cut the string into two strings, left and right, 
	# then use str_cat with left to concatinate it with substr, use it again to concatinate the whole thing again with right.
		for (( i = 1; i < $LEN; i++ )); do
		if [ "$i" -eq "$index" ]; then
			left=$(str_sub "$str" 0 "$i");
			right=$(str_sub "$str" "$i");
			left=$(str_cat "$left" "$substr");
			echo $(str_cat "$left" "$right");
			return 0;
		fi
	done
}

# 9- str_remove1 (str, substr, ALL) - Removes 'substr' from 'str' and returns the new string. 
#								 If "ALL" is passed, all instances will be removed.
function str_remove1() {
	echo $(str_replace "$1" "$2" "" "$3");
}

# 10- str_remove2 (str, index, n_chars) - Deletes 'n_chars' number of chars from 'str' starting at 'index'
function str_remove2() {
	str="$1";
	index="$2";
	n_chars="$3";

	# the idea, again, is to loop till we reach our index, once we do, we cut the string into 'left' and 'right'
	# 'left' starts from 0 to our index, right starts from (that's the key) index+n_chars to the end. 
	# Then just concatinate, and return the new concatinated string.
	for (( i = 0; i < $(str_len "$str"); i++ )); do
		if [ "$i" -eq "$index" ]; then
			left=$(str_sub "$str" 0 "$index");
			right=$(str_sub "$str" "$index"+"$n_chars");
			echo $(str_cat "$left" "$right");
			return 0;
		fi
	done;
	return 1;
}


# 11- str_ch2int (char) - Returns the numerical value of 'char'
function str_ch2int() {
	char="$1";
	printf "%d" \'"$char"
}

# 12- str_cmp (str1, str2) - Returns 0 if str1==str2, 
# 								 1 if str1 > str2 (str1 comes after str2 alphabatically)
#								-1 if the opposite
function str_cmp() {
	str1="$1";
	str2="$2";
	len1=$(str_len "$str1");
	len2=$(str_len "$str2");
	for (( i = 0; i < $len1 && i < $len2; i++ )); do
		val_1=$(str_ch2int "$(str_getch "$str1" "$i")");
		val_2=$(str_ch2int "$(str_getch "$str2" "$i")");
		if [ "$val_1" -gt "$val_2" ]; then
			echo 1;
			return 1;			
		elif [ "$val_2" -gt "$val_1" ]; then
			echo -1;
			return 2;
		fi
	done
	echo 0;
	return 0;
}

# 13- str_getext (file) - Returns the extenstion of 'file'.
function str_getext() {
	path="$1";
	

	# 0- using awk
	TMP="/tmp/STR_GETEXT";
	echo $path > $TMP;
	file=$(cat $TMP | awk -F "/" '{print $NF}');
	ext=${file#*.};

	# 1- using str_indexof + str_sub
	# indexofslash=$(str_indexof "$path" "/" LAST);
	# file=$(str_sub "$path" "$indexofslash"+1);
	# indexofdot=$(str_indexof "$file" "." 1);
	# ext=$(str_sub "$file" $indexofdot+1);

	# $ext would be equal to $file if $file didn't have an extension.
	test "$ext" = "$file";
	if [ $? -eq 0 ]; then
		echo "";
		return 1;
	fi
	echo "$ext";
	return 0;
}

# TESTING str_len
# len=$(str_len "$1");
# echo $len;

# TESTING str_cat
# string=$(str_cat "$1" "$2");
# echo -e $string;

# TESTING str_sub
# echo `str_sub "$1" $2 $3`

# TESTING str_contain
# str_contain "$1" "$2";
# if [ $? -eq 0 ];then # or just  if str_contain "hello world" "hello";
# 	echo 'got it'
# else
# 	echo 'nop'
# fi;

# TESTING str_getch
# echo `str_getch "hello" 0`
# str_getch "$1" $2;
# echo $?

# TESTING str_replace
# echo `str_replace "$1" "$2" "$3" "$4"`

# TESTING str_indexof
# echo `str_indexof "$1" "$2" "$3"`;

# TESTING str_insert
# echo $(str_insert "$1" "$2" "$3");

# TESTING str_remove1
# echo $(str_remove1 "$1" "$2" "$3");

# TESTING str_remove2
# echo $(str_remove2 "$1" "$2" "$3");

# TESTING str_ch2int
# echo $(str_ch2int "$1")

# TESTING str_cmp
# echo $(str_cmp "$1" "$2");

# TESTING str_getext
echo $(str_getext "crap");

