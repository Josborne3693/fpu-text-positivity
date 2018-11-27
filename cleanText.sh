#!/bin/bash

inFile=$1
outFile=$2

# First make everything lowercase
tr '[:upper:]' '[:lower:]' < $inFile > temp.txt

# Then do the mass sed cleaning
./cleanTweets.sed temp.txt > $outFile

# remove temp.txt
rm temp.txt
