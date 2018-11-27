#!/bin/sh

#  live_fasttext.sh
#  
#
#  Created by Jonathan on 11/27/18.
#  

FASTTEXT="./fastText/fasttext"
MODEL="model.bin"



$FASTTEXT predict $MODEL - < $(./cleanText.sh )/dev/stdin
