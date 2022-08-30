#!/bin/bash
ls | grep '-' | tee buildkite_user_htmls.list

echo > buildkite_user_htmls.csv
while IFS= read -r url
do
 	NAME="$(htmlq -f $url --text title | head -n 1 | cut -d '·' -f 2 | xargs)"
	TEAMS="$(htmlq -f $url -p --text div div div section | tail -n 1 | sed 's/Remove/,/g')"
	echo $NAME, $TEAMS >> buildkite_user_htmls.csv
done < buildkite_user_htmls.list # that is file we used in the python 