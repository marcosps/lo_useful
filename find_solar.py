#!/usr/bin/env python

import os
import sys

solar_defs = []

in_comment = False

def buildSolarDefs():
	f = open('include/tools/solar.h')

	#print f.readlines()

	for lines in f:

		if '/*' in lines:
			in_comment = True
		if '*/' in lines:
			in_comment = False

		if not in_comment:
			#print lines
			if "typedef" in lines:
				# get only the typedefed variable name
				lines = lines.replace('typedef ', '').split(';', 1)[0].rsplit(' ', 1)[1]

				# remove size of array from the definition
				if '[' in lines:
					lines = lines.split('[', 1)[0]

				#print 'typedef: ' + lines
				solar_defs.append(lines)

			if '#define ' in lines:

				# we skip defines of include guards
				if len(lines.split(' ')) == 2:
					continue

				# get only the macro name
				lines = lines.replace('#define ', '')
				if '(' in lines:
					lines = lines.split('(', 1)[0]

				if len(lines.split(' ')) > 1:
					lines = lines.split(' ', 1)[0]

				#print 'define: ' + lines
				if lines not in solar_defs:
					solar_defs.append(lines)

	f.close()

buildSolarDefs()
print solar_defs

for root, dirs, files in os.walk('.'):

	if 'external' in dirs:
		dirs.remove('external')
	if 'workdir' in dirs:
		dirs.remove('workdir')
	if 'instdir' in dirs:
		dirs.remove('instdir')

	for f in files:
		if f.endswith(".c") or f.endswith('.cxx') or f.endswith('.h') or f.endswith('.hxx'):
			filename = os.path.join(root, f)
			#print 'File ' + filename
			with open(filename, 'r') as local_file:

				# check if we have solar.h included in the file
				if 'tools/solar.h' in local_file.read():
					#print ('%s has solar.h') % (filename)
					line_number = 0

					# return the file cursor
					local_file.seek(0)

					found = False

					for line in local_file:
						line_number += 1

						for element in solar_defs:
							if element in line:
								found = True
								print ('%s: definition of solar found: %s used in line %d') % \
										(filename, line, line_number)

					if not found:
						print ('%s don\'t need to include solar.h') % (filename)
