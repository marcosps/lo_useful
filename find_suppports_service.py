#!/usr/bin/env python

import os
import sys

for root, dirs, files in os.walk('.'):
        if 'external' in dirs:
                dirs.remove('external')
        if 'workdir' in dirs:
                dirs.remove('workdir')
        if 'instdir' in dirs:
                dirs.remove('instdir')

        for f in files:
		if f.endswith('.c') or f.endswith('.cxx') or f.endswith('.h') or f.endswith('.hxx'):
			filename = root + '/' + f
			local_file = open(filename, 'r')
			line_number = 0
			in_supports_service = False

			for line in local_file:
				line_number = line_number + 1

				if in_supports_service:
					if 'cppu::supportsService' in line:
						break # next file with success
					elif '}' in line:
						print ('%s: Needs to convert to supports service in line %d') % (filename, line_number)
						break # next file with failure

				elif '::supportsService' in line:
					in_supports_service = True

			local_file.close()
