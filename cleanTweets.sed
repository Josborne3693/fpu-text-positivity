#!/usr/bin/sed -E -f
#
# This script cleans the text of each line of the input file
# It was created specifically for cleaning Tweets
#
# The regexes are in a specific order, so if you want to tinker,
# keep in mind that later ones may be dependent on the output
# of earlier ones
#
# Created by Jonathan Osborne
# josborne3693@floridapoly.edu

# Delete '&amp;'s and such
s/&[a-z]+;//g

# Delete twitter '@handle's
s/@[^ ]+[\n\r]|@[^ ]+//g

# Delete hyperlinks. Accounts for inline and endline links
s/https?[^ ]+$|https?[^ ]+ //g

# Delete leading and trailing whitespace
# E.g. ' foo   bar baz  ' -> 'foo   bar baz'
# Assumes only spaces
s/^[ ]+|[ ]+$//g

# Make multiple whitespaces single
# E.g. 'foo   bar' -> 'foo bar'
s/[[:blank:]]{2,}/ /g

# Get rid of all apostrophes
s/\'//g

# Make punctuation separating alphanumeric characters a space
# E.g. 'foo...bar' -> 'foo bar'  'baz,qux -> 'baz qux'
s/([[:alnum:]])[[:punct:]]+([[:alnum:]])/\1 \2/g


# Get rid of all other punctuation, but leave hashtags
# This is convoluted because I could not figure out how
# to subtract the '#' character fron [[:punct:]]
# 's/[[:punct:]-[#]]//g' should have worked, I believe

# Change all '#' characters to the 'H' character
s/#/H/g

# Remove all punctuation
s/[[:punct:]]//g

# Change all 'H' characters back to the '#' character
s/H/#/g


# One last whitespace clean
s/^[ ]+|[ ]+$//g
s/[[:blank:]]{2,}/ /g
