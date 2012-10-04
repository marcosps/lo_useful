#!/bin/bash
# get_developers_score.sh

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# This script was made to list how many some people already changed in LO

for name in "Marcos Paulo de Souza" "José Guilherme Vanz" "Olivier Hallot" "Ricardo Montania"
do
	echo $name
	git log --numstat --pretty="%H" --author="$name" | awk 'NF==3 {plus+=$1; minus+=$2}; END \
								{printf("+%d, -%d\n", plus, minus)}'

done
