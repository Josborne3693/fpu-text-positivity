#!/bin/bash

# This is the main script for taking a file of text
# and classifying each line, or the entire file,
# based on an emotional scale
#
# 5 is the most happiness
# 4
# 3
# 2
# 1 is the lowest amount of happiness
#
# The resulting classifications are placed in ./predictions/[1-5]
#
# Created by Jonathan Osborne
# josborne3693@floridapoly.edu


# fastText executable
FASTTEXT="./fastText/fasttext"
# Model to use for prediction
MODEL="model.bin"

function init_file_vars {
    FILEPATH="$1"
    if [ $FILEPATH != "" ]
    then
        # Input file to use as source for classificatoin
        FULLFILENAME="$( basename -- $FILEPATH )"
        FILENAME="${FULLFILENAME%.*}"
        PREDDIR="./predictions/$FILENAME"
        PREDONLY="$PREDDIR/predict_$FILENAME.txt"
        PREDTEXT="$PREDDIR/all_$FILENAME.txt"
        CLEANTEXT="$PREDDIR/clean_$FILENAME.txt"
    else
        echo "Error: No filename given"
        exit -1
    fi
}

function print_help {
    echo ""
    echo "usage:  $0 [-h] | [-f | -l | -L] file"
    echo "-- classifies text into the predictions folder --"
    echo ""
    echo "where:"
    echo "-h | --help   show this help text"
    echo "-l | --lines  classify each line of the file individually"
    echo "-f | --file   classify the entire file as if it were one line"
    echo "-L | --live   classify each line input to stdin"
    echo "            - live should only contain [a-z]*[0-9]*[#]*"
    echo ""
    echo "NOTE: if the input filename already exists in the"
    echo "predictions folder, those files WILL be overwritten"
    exit 1
}

function init_files {
    mkdir -p $PREDDIR
    for i in `seq 1 5`;
    do
        cat /dev/null > $PREDDIR/__label__$i.txt
    done
    cat /dev/null > $PREDONLY
    cat /dev/null > $PREDTEXT
    cat /dev/null > $CLEANTEXT
}

function classify_lines {
    echo "-Classifying $FULLFILENAME line by line-"
    init_files

    # Clean text for prediction
    echo "-Cleaning text-"
    ./cleanText.sh $FILEPATH $CLEANTEXT

    # Make predictions off of cleaned text
    echo "-Making predictions-"
    $FASTTEXT predict $MODEL $CLEANTEXT > $PREDONLY

    # Put predictions and text together into one file
    paste -d "\ " $PREDONLY $FILEPATH > $PREDTEXT

    # Put the lines in their place
    echo "-Distributing lines-"
    for i in `seq 1 5`;
    do
    cat $PREDTEXT | grep "__label__$i" | sed -E "s/(__label__$i )(.*)/\2/" > $PREDDIR/__label__$i.txt
    done
}

function classify_file {
    local FILEPATH="$1"
    if [ $FILEPATH != "" ]
    then
        FULLFILENAME="$( basename -- $FILEPATH )"
        FILENAME="${FULLFILENAME%.*}"
        # Clean text for prediction
        echo "-Cleaning text-"
        ./cleanText.sh $FILEPATH .tmp1

        # Make the text one line and predict it
        echo "-Classifying the entire file $FILEPATH-"
        echo $( tr '\n' ' ' < .tmp1) > .tmp2
        prediction="$($FASTTEXT predict $MODEL .tmp2)"
        # Comment out the following line to keep the cleaned data
        rm .tmp1 .tmp2

        mkdir -p "./predictions"
        cp $FILEPATH "./predictions/$prediction-$FULLFILENAME"
    else
        echo "Error: No filename given"
        exit -1
    fi

}

function classify_live {
    echo "-Classifying your input-"
    echo "-Use 'ctrl+c' to exit-"
    $FASTTEXT predict $MODEL -
}


# Let's parse some args

# -h or --help will be dealt with first
# I chose to have the program quit if help is requested
# Otherwise
# Must have (-l | --lines) OR (-f | --file) OR (-L | --live)
# -l | --lines will classify each line of the file individually
# -f | --file will classify the entire file as if it were one line
# -L | --live will classify each line input to stdin

key="$1"
case $key in
    -h|--help)
        print_help
        ;;
    -l|--lines)
        init_file_vars $2
        classify_lines
        ;;
    -f|--file)
        classify_file $2
        ;;
    -L|--live)
        classify_live
        ;;
    *)
        print_help
        ;;
esac

