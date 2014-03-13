#!/usr/bin/env python

import os
import sys

sal_types = ['sal_uLong', 'sal_uIntPtr']

path = sys.argv[1] if len(sys.argv) > 1 else '.'

for root, dirs, files in os.walk(path):

	if 'external' in dirs:
		dirs.remove('external')
	if 'workdir' in dirs:
		dirs.remove('workdir')
	if 'instdir' in dirs:
		dirs.remove('instdir')

	for f in files:

		if f.endswith(".c") or f.endswith('.cxx') or f.endswith('.h') or f.endswith('.hxx'):

			filename = os.path.join(root, f)

			with open(filename, 'r') as f:

				lines = f.read()

				found = []

				for t in sal_types:
					if t in lines:
						found.append(t)

				if found:
					print('%s: Contains %s. Replace by sal_uInt32, sal_uInt64, size_t or "unsigned int".' % (filename, ' and '.join(found)))