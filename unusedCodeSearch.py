#!/usr/bin/env python
# -*- encoding: utf-8 -*-
# file: unusedCodeSearch.py

'''
    all the imports
'''
import os, sys, fnmatch


'''
    all defines
'''
headers="--hxx"
sources="--cxx"


'''
    all the functions
'''
# always return a list with 3 objects: extension, type, and path
def validParameters():
    nParam = len(sys.argv)-1
    paramReceived = []

    if not nParam or nParam > 3:
        print ("Invalid syntax. Try --help")
        sys.exit(1)


    # new code
    if nParam == 1:
        if str(sys.argv[1]) == "-h" or str(sys.argv[1]) == "--help":
            helpMessage()
        else:
            print ("Invalid syntax. Try --help ")
            sys.exit(1)

    elif nParam == 2:
        paramA = sys.argv[1].split('=')
        paramB = sys.argv[2].split('=')
        if str(sys.argv[1]) == "-h" or str(sys.argv[1]) == "--help":
            print ("For help inform only --help or -h")
            sys.exit(1)

        if len(paramA) != 2:
            print ("Unrecognized option: " + paramA + ", try --help")
            sys.exit(1)
        if len(paramB) != 2:
            print ("Unrecognized option: " + paramB + ", try --help")
            sys.exit(1)

        if paramA[0] != "-s" and paramA[0] != "--source":
            print ("Unrecognized option: " + sys.argv[1])
            sys.exit(1)

        elif paramB[0] != "-t" and paramB[0] != "--type":
            print ("Unrecognized option: " + sys.argv[2])
            sys.exit(1)
        else:
            paramReceived.append(paramA[1])
            paramReceived.append(paramB[1])
            paramReceived.append(getPath())
            return paramReceived

    elif nParam == 3:
        paramA = sys.argv[1].split('=')
        paramB = sys.argv[2].split('=')
        paramC = sys.argv[3].split('=')
        if str(sys.argv[1]) == "-h" or str(sys.argv[1]) == "--help":
            print ("For help inform only --help or -h")
            sys.exit(1)

        if len(paramA) != 2:
            print ("Unrecognized option: " + str(sys.argv[1]) + ", try --help")
            sys.exit(1)
        if len(paramB) != 2:
            print ("Unrecognized option: " + str(sys.argv[2]) + ", try --help")
            sys.exit(1)
        if len(paramC) != 2:
            print ("Unrecognized option: " + str(sys.argv[3]) + ", try --help")
            sys.exit(1)

        if paramA[0] != "-s" and paramA[0] != "--source":
            print ("Unrecognized option: " + sys.argv[1])
            sys.exit(1)

        elif paramB[0] != "-t" and paramB[0] != "--type":
            print ("Unrecognized option: " + sys.argv[2])
            sys.exit(1)

        elif paramC[0] != "-p" and paramC[0] != "--path":
            print ("Unrecognized option: " + sys.argv[3])
            sys.exit(1)

        elif paramA[0] == "-s" or paramA[0] == "--source" and paramB[0] == "-t" or paramB[0] == "--type" and paramC[0] == "-p" or paramC[0] == "--path":
            paramReceived.append(paramA[1])
            paramReceived.append(paramB[1])
            paramReceived.append(paramC[1])
            return paramReceived


def getPath():
    path = os.getcwd()
    return path

def createList(directory, pattern):
    # code and credits by http://stackoverflow.com/questions/2186525/use-a-glob-to-find-files-recursively-in-python
    def find_files(directory, pattern):
        for root, dirs, files in os.walk(directory):
            for basename in files:
                if fnmatch.fnmatch(basename, pattern):
                    filename = os.path.join(root, basename)
                    yield filename
    fullList = []
    for filename in find_files(directory, pattern):
        fullList.append(filename)

    return fullList

def cleanFiles():
    print ("Under construction...")

def helpMessage():
    print ("Usage:\n")
    print ("python unusedCodeSearch.py --source=x --type=x --path=x\n")
    print ("Sources: Any extension file")
    print (" -s  or  --source=cxx        - Search in cxx files only")
    print (" -s  or  --source=hxx        - Search in hxx files only")
    print (" -s  or  --source=java       - Search in java files only")
    print (" -s  or  --source=any        - Search in any file\n")
    print ("Types: Can be macro or method by now")
    print (" -t  or  --type=macro        - Search for macros")
    print (" -t  or  --type=method       - Search for methods\n")
    print ("Path: the path where you want looking for")
    print (" PS 1: Works fine for relative or absolut path.")
    print (" PS 2: If no path was informed, current folder will be used instead.\n")
    print (" -p  or  --path=$HOME        - Search from $HOME\n")
    print (" -h  or  --help              - Show this message.\n")
    sys.exit(0)
    




'''
    script begin
'''
# validate the input parameters and inform a message
paramReceived = validParameters()
searchIn      = paramReceived[0]
searchFor     = paramReceived[1]
searchWhere   = paramReceived[2]
print ("Search in "  + str(searchIn)  + " files.")
print ("Search for " + str(searchFor) + " type.")
print ("Search in " + str(searchWhere) + " folder.\n")

if searchIn == "any":
    searchIn = "*.*"
else:
    searchIn = "*." + searchIn

fullList = createList(searchWhere, searchIn)

print (str(len(fullList)) + " files found!")

# now: pegar cada arquivo e abrir conforme o caso!