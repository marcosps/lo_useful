#!/usr/bin/env python

import os
import re
import sys

def check(file_name):

	with open(file_name, 'r') as f:

		text = f.read().split('\n')
		i = 0
		while i < len(text):
			if not text[i].startswith('//') and '::supportsService' in text[i] and 'cppu' not in text[i]:
				while '{' not in text[i]:
					i = i + 1

				if  '{' in text[i]:
					if 'SAL_' in text[i + 1] or 'OSL_' in text[i + 1] or not text[i + 1].strip():
						i = i +1

					if 'cppu::supportsService' in text[i + 1] and '}' in text[i + 2]:
						"ok here..."
					else:
						print('%s: Needs to be converted to cppu::supportsService at line %d.') % (file_name, i + 1)

			i = i + 1

def walk(path):

	print('Current path: ' + path)

	for root, dirs, files in os.walk(path):

		if 'external' in dirs:
			dirs.remove('external')

		if 'workdir' in dirs:
			dirs.remove('workdir')

		if 'instdir' in dirs:
			dirs.remove('instdir')

		for f in files:
			
			if f.endswith('.c') or f.endswith('.cxx') or f.endswith('.h') or f.endswith('.hxx') and 'supportsservice.hxx' not in f:

				file_name = os.path.join(root, f)
				#print file_name
				check(file_name)


if __name__ == '__main__':

	if len(sys.argv) > 1:
		path = sys.argv[1]
	else:
		path = '.'

	walk(path)
