#!/usr/bin/env python

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# Author: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
# This script will help to find duplicate includes and using declarations

import os
import sys

def verifyIncludes(filename):
	f = open(filename, 'r')

	list_includes = []
	linen = 0
	in_comment = False

	for line in f:
		linen = linen + 1
		if '/*' in line:
			in_comment = True
		if '*/' in line:
			in_comment = False

		if not in_comment:
			if line.startswith('#include'):
				includeName = line.split(' ')

				# remove multiple spaces between #include and <something.h>
				if len(includeName) > 2:
					includeName = ' '.join(includeName)
					includeName = includeName.split('#include')

				if len(includeName) == 1:
					# we don't have a space after the #include clause
					includeName = line.split('#include')

					if len(includeName) == 2:
						includeName = includeName[1]
					else:
						print 'Error while trying to get the include name in file/line: ' + filename + '/' + str(linen)
				else:
					includeName = includeName[1]

				includeName = includeName.replace('\n', '')

				if includeName in list_includes:
					print filename + ': Include ' + includeName + ' appears twice on line ' + str(linen)
				else:
					list_includes.append(includeName)
	f.close()
			

def verifyUsing(filename):
	f = open(filename, 'r')
	f.close()

def helpMessage():
	print '		[--]include	- Shows the duplicated includes in files'
	print '		[--]using	- Shows the duplicated using clauses in files'
	print '		[--]both		- Two options combined'
	print '		[--]help		- Show this message'


# begin script
if len(sys.argv) < 2:
	helpMessage()
	sys.exit()
elif sys.argv[1] not in ['--include', 'include', 'using', '--using', '--both', 'both']:
	if sys.argv[1] != 'help' and sys.argv[1] != '--help':
		print 'Unknow paramter! Use one of them'
	helpMessage()
	sys.exit()

includeCheck = False
usingCheck = False

if 'include' in sys.argv[1] or 'both' in sys.argv[1]:
	includeCheck = True
if 'using' in sys.argv[1] or 'both' in sys.argv[1]:
	usingCheck = True

for root, dirs, files in os.walk('.'):

	if 'external' in dirs:
		dirs.remove('external')
	if 'workdir' in dirs:
		dirs.remove('workdir')
	if 'instdir' in dirs:
		dirs.remove('instdir')

	for f in files:
		# skip hidden files
		if f.startswith('.'):
			continue

		if '.cxx' in f or '.c' in f or '.h' in f or '.hxx' in f:
			filepath = root + '/' + f
			if includeCheck:
				verifyIncludes(filepath)
			if usingCheck:
				verifyUsing(filepath)
