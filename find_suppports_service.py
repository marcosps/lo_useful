#!/usr/bin/env python

import os
import re
import sys

if len(sys.argv) > 1:
	path = sys.argv[1]
else:
	path = '.'

print('Current path: ' + path)

regex = re.compile('sal_Bool ([a-zA-Z_0-9]*)::supportsService')

for root, dirs, files in os.walk(path):

	if 'external' in dirs:
		dirs.remove('external')

	if 'workdir' in dirs:
		dirs.remove('workdir')

	if 'instdir' in dirs:
		dirs.remove('instdir')

	for f in files:

		if f.endswith('.c') or f.endswith('.cxx') or f.endswith('.h') or f.endswith('.hxx'):

			filename = os.path.join(root, f)

			with open(filename, 'r') as local_file:
				line_number = 0

				for line in local_file:

					line_number += 1

					if regex.match(line):
						print ('%s: Needs to convert supportsService at line %s.' % (filename, line_number))
						break
