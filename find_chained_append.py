import os
import sys

for root, dirs, files in os.walk('.'):

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
                        line_number = 0
                        in_comment = False
                        
                        filepath = root + '/' + file
                        
                        f = open(filepath, 'r')
                        
                        for line in f:
                                line_number = line_number + 1
                                
                                if '/*' in line:
                                        in_comment = True
                                if '*/' in line:
                                        in_comment = False
                                
                                if not in_comment:
                                        if '.append(' in line:
                                                print('%s in line: %d') % (filepath, line_number)
                        
                        f.close()