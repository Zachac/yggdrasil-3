#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

for com in $DIR/bin/*; do
	alias $(basename $com)="source $com"
done

for ali in $DIR/aliases/*; do
	alias $(basename $ali)="source $DIR/bin/$(cat $ali)"
done

