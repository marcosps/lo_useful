#!/usr/bin/env python

import os
import sys

if len(sys.argv) > 1:
	path = sys.argv[1]
else:
	path = '.'

print('Current path: ' + path)

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

			#print('Scanning file: ' + filename)

			with open(filename, 'r') as local_file:
				line_number = 0
				in_supports_service = False

				lines = []

				for line in local_file:

					line_number = line_number + 1

					if 'cppu::supportsService' in line:
						continue
					elif '::supportsService' in line:
						lines.append(line_number)
						continue

				if len(lines) > 0:
					print ('%s: Needs to convert supportsService in lines %s.') % (filename, ', '.join([str(x) for x in lines]))