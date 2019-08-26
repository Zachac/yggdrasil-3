#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

PATH=$PATH:$DIR/bin/

for com in $DIR/bin/*; do
	alias $(basename $com)=$com
done

