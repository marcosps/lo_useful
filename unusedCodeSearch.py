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
    sourceExtensions = ['any','c','h','cxx','hxx','java','mm']
    typeExtensions   = ['macros','classes']
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

        # validate the first options, -s, --source, -t and --type
        if paramA[0] != "-s" and paramA[0] != "--source":
            print ("Unrecognized option: " + sys.argv[1] + ", try --help")
            sys.exit(1)

        elif paramB[0] != "-t" and paramB[0] != "--type":
            print ("Unrecognized option: " + sys.argv[2] + ", try --help")
            sys.exit(1)

        # validate the extension received
        try:
            index = sourceExtensions.index(paramA[1])
        except ValueError:
            index = -1
        if index == -1:
            print ("Unrecognized extension: " + paramA[1] + ", try --help")
            sys.exit(1)

        # validate the type received
        try:
            index = typeExtensions.index(paramB[1])
        except ValueError:
            index = -1
        if index == -1:
            print ("Unrecognized type: " + paramB[1] + ", try --help")
            sys.exit(1)
        
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
            print ("Unrecognized option: " + sys.argv[1] + ", try --help")
            sys.exit(1)

        elif paramB[0] != "-t" and paramB[0] != "--type":
            print ("Unrecognized option: " + sys.argv[2] + ", try --help")
            sys.exit(1)

        elif paramC[0] != "-p" and paramC[0] != "--path":
            print ("Unrecognized option: " + sys.argv[3] + ", try --help")
            sys.exit(1)

        elif paramA[0] == "-s" or paramA[0] == "--source" and paramB[0] == "-t" or paramB[0] == "--type" and paramC[0] == "-p" or paramC[0] == "--path":

            # validate the extension received
            try:
                index = sourceExtensions.index(paramA[1])
            except ValueError:
                index = -1
            if index == -1:
                print ("Unrecognized source extension: " + paramA[1] + ", try --help")
                sys.exit(1)

            # validate the type received
            try:
                index = typeExtensions.index(paramB[1])
            except ValueError:
                index = -1
            if index == -1:
                print ("Unrecognized type: " + paramB[1] + ", try --help")
                sys.exit(1)

            # validate the path received
            if not os.path.isdir(paramC[1]):
                print ("Invalid path: " + str(paramC[1]))
                sys.exit(1)
                
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

def helpMessage():
    print ("Usage:\n")
    print ("python unusedCodeSearch.py --source=x --type=x --path=x\n")
    print ("Sources: Any extension file")
    print (" -s  or  --source=cxx        - Search in cxx files only")
    print (" -s  or  --source=hxx        - Search in hxx files only")
    print (" -s  or  --source=java       - Search in java files only")
    print (" -s  or  --source=any        - Search in any file")
    print (" PS: By now, valid extensions can be: any, c, h, cxx, hxx, java, mm\n")
    print ("Types: Can be macro or method by now")
    print (" -t  or  --type=macros       - Search for macros")
    print (" -t  or  --type=classes      - Search for methods\n")
    print ("Path: the path where you want looking for")
    print (" PS 1: Works fine for relative or absolut path.")
    print (" PS 2: If no path was informed, current folder will be used instead.\n")
    print (" -p  or  --path=$HOME        - Search from $HOME\n")
    print (" -h  or  --help              - Show this message.\n")
    sys.exit(0)
    

def removeEmpty(fullList, sourceType):
    if sourceType == "macros":
        lookFor = "#define"
    elif sourceType == "classes":
        lookFor = "class"

    for eachFile in fullList:
        aFile = open(eachFile, "r")
        index = []
        count = 0
        for line in aFile:
            if line.startswith( lookFor ):
                index.append(count)
            count += 1

        # verify until 3 lines before the #define line if there is an line starting with #if (#ifdef, #ifndef)
        aFile.seek(0)
        count = 0
        index2 = []
        for position in index:
            count = position - 3
            read = 0
            while read < count:
                t = aFile.readline()
                read += 1
            if "#if" in aFile.readline():
                index2.append("it's on line 1")
            elif "#if" in aFile.readline():
                index2.append("it's on line 2")
            elif "#if" in aFile.readline():
                index2.append("it's on line 3")

        # if index2 is empty, there is any #if before #define, and if not, ... miss code here :P



'''
    script begin
'''
# validate the input parameters and inform a message
paramReceived = validParameters()
searchIn      = paramReceived[0]
searchFor     = paramReceived[1]
searchWhere   = paramReceived[2]
print ("Search in "  + str(searchIn)    + " files.")
print ("Search for " + str(searchFor))
print ("Search in "  + str(searchWhere) + " folder.\n")

if searchIn == "any":
    searchIn = "*.*"
else:
    searchIn = "*." + searchIn

fullList = createList(searchWhere, searchIn)

if not len(fullList):
    print (" No files found!")
    tStop = False
else:
    print (str(len(fullList)) + " files found!")
    tStop = True


if searchFor == "macros" and tStop:
    print ("Now looking for macros.")
    # remove files which don't have #defines
    newList = removeEmpty(fullList, searchFor)

elif searchFor == "classes" and tStop:
    print ("Now looking for methods.")
    # remove files which don't have classes
    newList = removeEmpty(fullList, searchFor)
    
'''  Test line '''
