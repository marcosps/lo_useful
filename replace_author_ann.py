  #This program is free software. You can redistribute it and/or modify
  # is under the terms of the GNU Gerenal Public License as published by
  # the Free Software Foundation, either version 2 of the License, or
  # any later version.

# This python source contains tools. So, if you have a good ideia... Implement!
# My Python skills is not so good. So, if you have some tips tell me and Implement it!  :) 

import os

def removeAnn(files):
	name = os.path.abspath(files)
	tempName = name + ".temp"
	newFile = open(tempName, "w")
	for line in open(files).readlines():
		if line.find("@author") == -1:
			newFile.write(line)
	
	os.remove(name)
	os.rename(tempName,name)	

def removeFrom(path):
	for files in os.listdir(path):
		if os.path.isdir(files):
			removeFrom(files)
		if files.endswith('.java'):
			removeAnn(files)


# This function will remove all @author annotations found in the java sources
# TODO - It's necesary remove empty comments
# TODO - It's necessary take care about remove the begining or end of comments when we remove @author annotation
def removeAuthorAnn():
	print 'Removing the annotations'
	path = raw_input('Inform the path:  ')
	if os.path.exists(path):
		print 'Remove all annotations on ' + path
		removeFrom(path)
	else:
		print 'Invalid path! :-('

print 'Hello! This script will search in java source for @author annotations and will remove it.'
x = raw_input('Can we start?[y]es or [n]o:  ')

if x == 'y':
	removeAuthorAnn();
print 'Bye!'

