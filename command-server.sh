#!/usr/bin/env bash

# Create an exclusive right named pipe in tmp to receive and execute
# Arbitrary commands.

FIFO_FILE=/tmp/command-server-pipe
if [ -e $FIFO_FILE ] ; then
	rm $FIFO_FILE
fi
mkfifo $FIFO_FILE

declare -i count=1
# while cmd="$(tail -1 $FIFO_FILE)" ; do
while IFS='#' read -r cmddir cmd <<<"$(tail -1 $FIFO_FILE)" ; do
	cd "$cmddir"
	echo -e "in \e[7m$PWD$(tput sgr0)"
	echo -e ">> \e[7m$cmd$(tput sgr0)"
	eval "$cmd"
	colcount=$(tput cols)
	printf -v termwidthline '%*s' $colcount
	echo -e "\e[7m$(tput setaf 5)${termwidthline// /-}"
	printf "#%-3s ^%-$((colcount-6))s\n" $count "$cmd"
	echo -e "${termwidthline// /-}$(tput sgr0)"
	count+=1
done

