#!/usr/bin/env python

import os
import re
import sys

def check(file_name):

	with open(file_name, 'r') as f:

		text = f.read()
		s = 'sal_Bool(.)((SAL_CALL)(.))?([a-zA-Z0-9])+::supportsService'
		starts = [match.start() for match in re.finditer(s, text)]

		for start in starts:
			braces = 0
			first_brace = -1
			last_brace = -1
			i = start

			while True:

				if i >= len(text):# or (first_brace != -1 and last_brace != -1):
					break

				c = text[i]

				if c == '{':
					braces += 1
					if first_brace == -1:
						first_brace = i

				elif c == '}':
					braces -= 1

					if braces < 0:
						raise Exception('Invalid file. To many braces open.')
					elif braces == 0:
						last_brace = i + 1
						break

				i += 1

			if braces > 0 or first_brace < 0 or last_brace < 0:
				raise Exception('Invalid file. Can''t find method closure.')

			scope = text[first_brace:last_brace]

			if not 'cppu::supportsService' in scope:
				print('%s: Needs to be converted to cppu::supportsService at line %d.' % (file_name, gel_line(text, start)))

def gel_line(text, position):

	lines = text.splitlines()
	lines_size = [len(x) for x in lines]

	pos = 0
	line = 0

	for l in lines_size:
		pos += l
		line += 1

		if pos >= position:
			return line

	return line

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

			if f.endswith('.c') or f.endswith('.cxx') or f.endswith('.h') or f.endswith('.hxx'):

				file_name = os.path.join(root, f)
				check(file_name)


if __name__ == '__main__':

	if len(sys.argv) > 1:
		path = sys.argv[1]
	else:
		path = '.'

	walk(path)