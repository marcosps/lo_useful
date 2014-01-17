import os
import re
import sys

def get_line(text, position):

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

def search(path):
	for root, dirs, files in os.walk(path):

		if 'external' in dirs:
			dirs.remove('external')
		if 'workdir' in dirs:
			dirs.remove('workdir')
		if 'instdir' in dirs:
			dirs.remove('instdir')

		for file in files:
			if file.startswith('.'):
				continue

			if '.cxx' in file or '.c' in file or '.h' in file or '.hxx' in file:

				filepath = os.path.join(root, file)

				with open(filepath, 'r') as f:
				
					text = f.read()
					s = '.append\('
					starts = [match.start() for match in re.finditer(s, text)] # Needs to scape comments
					
					if (starts):
						print('%s: Found %d append''s. First starts at line: %d' % (filepath, len(starts), get_line(text, starts[0])))


if __name__ == '__main__':

	if len(sys.argv) > 1:
		path = sys.argv[1]
	else:
		path = '.'

	search(path)
