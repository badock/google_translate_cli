#!/bin/bash

# This function is convenient when encoding a string to be used in a query part
# of a URL, as a convenient way to pass variables to the next page.
url_encode() {
    local l=${#1}
    for (( i = 0 ; i < l ; i++ )); do
        local c=${1:i:1}
        case "$c" in
            [çéèa-zA-Z0-9.~_-]) printf "$c" ;;
            ' ') printf + ;;
            *) printf '%%%X' "'$c"
        esac
    done
}

# Decodes any %## encoding in the given string. Plus symbols ('+') are decoded
# to a space character.
url_decode() {
    local data=${1//+/ }
    printf '%b' "${data//%/\x}"
}

from=$1
to=$2
sentence=$3

encoded_sentence=$(url_encode "$sentence")
cmd="curl -s -A 'Mozilla/5.0' http://translate.google.fr/translate_a/t?client=t&text=$encoded_sentence&hl=en&sl=$from&tl=$to&ie=UTF-8&oe=UTF-8&multires=1&otf=2&rom=1&ssel=0&tsel=0&sc=1"
answer=`$cmd`

I=4
COUNT=0
while [  $COUNT -lt 1 ]; do

	if [ "${answer:$I:1}" == "\"" ]; then
    	COUNT=1
    else    
    	result="$result${answer:$I:1}"
    fi

    let I=I+1
done
echo $result
