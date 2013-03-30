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
    nParam = len( sys.argv )-1
    sourceExtensions = ['any','c','h','cxx','hxx','java','mm']
    typeExtensions   = ['macros','classes']
    paramReceived = []

    if not nParam or nParam > 3:
        print( "Invalid syntax. Try --help" )
        sys.exit( 1 )


    # new code
    if nParam == 1:
        if str( sys.argv[1] ) == "-h" or str( sys.argv[1] ) == "--help":
            helpMessage()
        else:
            print( "Invalid syntax. Try --help" )
            sys.exit( 1 )

    elif nParam == 2:
        paramA = sys.argv[1].split( '=' )
        paramB = sys.argv[2].split( '=' )
        if str( sys.argv[1] ) == "-h" or str( sys.argv[1] ) == "--help":
            print( "For help inform only --help or -h" )
            sys.exit( 1 )

        if len(paramA) != 2:
            print( "Unrecognized option: " + paramA + ", try --help" )
            sys.exit( 1 )
        if len( paramB ) != 2:
            print( "Unrecognized option: " + paramB + ", try --help" )
            sys.exit( 1 )

        # validate the first options, -s, --source, -t and --type
        if paramA[0] != "-s" and paramA[0] != "--source":
            print( "Unrecognized option: " + sys.argv[1] + ", try --help" )
            sys.exit( 1 )

        elif paramB[0] != "-t" and paramB[0] != "--type":
            print( "Unrecognized option: " + sys.argv[2] + ", try --help" )
            sys.exit( 1 )

        # validate the extension received
        try:
            index = sourceExtensions.index( paramA[1] )
        except ValueError:
            index = -1
        if index == -1:
            print( "Unrecognized extension: " + paramA[1] + ", try --help" )
            sys.exit( 1 )

        # validate the type received
        try:
            index = typeExtensions.index( paramB[1] )
        except ValueError:
            index = -1
        if index == -1:
            print( "Unrecognized type: " + paramB[1] + ", try --help" )
            sys.exit( 1 )
        
        paramReceived.append( paramA[1] )
        paramReceived.append( paramB[1] )
        paramReceived.append( getPath() )
        return paramReceived

    elif nParam == 3:
        paramA = sys.argv[1].split( '=' )
        paramB = sys.argv[2].split( '=' )
        paramC = sys.argv[3].split( '=' )
        if str( sys.argv[1] ) == "-h" or str(sys.argv[1]) == "--help":
            print( "For help inform only --help or -h" )
            sys.exit( 1 )

        if len( paramA ) != 2:
            print( "Unrecognized option: " + str(sys.argv[1]) + ", try --help" )
            sys.exit( 1 )
        if len( paramB ) != 2:
            print( "Unrecognized option: " + str(sys.argv[2]) + ", try --help" )
            sys.exit( 1 )
        if len( paramC ) != 2:
            print( "Unrecognized option: " + str(sys.argv[3]) + ", try --help" )
            sys.exit( 1 )

        if paramA[0] != "-s" and paramA[0] != "--source":
            print( "Unrecognized option: " + sys.argv[1] + ", try --help" )
            sys.exit( 1 )

        elif paramB[0] != "-t" and paramB[0] != "--type":
            print( "Unrecognized option: " + sys.argv[2] + ", try --help" )
            sys.exit( 1 )

        elif paramC[0] != "-p" and paramC[0] != "--path":
            print( "Unrecognized option: " + sys.argv[3] + ", try --help" )
            sys.exit( 1 )

        elif paramA[0] == "-s" or paramA[0] == "--source" and paramB[0] == "-t" or paramB[0] == "--type" and paramC[0] == "-p" or paramC[0] == "--path":

            # validate the extension received
            try:
                index = sourceExtensions.index( paramA[1] )
            except ValueError:
                index = -1
            if index == -1:
                print( "Unrecognized source extension: " + paramA[1] + ", try --help" )
                sys.exit( 1 )

            # validate the type received
            try:
                index = typeExtensions.index( paramB[1] )
            except ValueError:
                index = -1
            if index == -1:
                print( "Unrecognized type: " + paramB[1] + ", try --help" )
                sys.exit( 1 )

            # validate the path received
            if not os.path.isdir( paramC[1] ):
                print( "Invalid path: " + str( paramC[1] ) )
                sys.exit( 1 )
                
            paramReceived.append( paramA[1] )
            paramReceived.append( paramB[1] )
            paramReceived.append( paramC[1] )
            return paramReceived


def getPath():
    path = os.getcwd()
    return path

def createList( directory, pattern ):
    # code and credits by http://stackoverflow.com/questions/2186525/use-a-glob-to-find-files-recursively-in-python
    def find_files( directory, pattern ):
        for root, dirs, files in os.walk( directory ):
            for basename in files:
                if fnmatch.fnmatch( basename, pattern ):
                    filename = os.path.join( root, basename )
                    yield filename
    fullList = []
    for filename in find_files( directory, pattern ):
        fullList.append( filename )

    return fullList

def helpMessage():
    print( "Usage:\n" )
    print( "python unusedCodeSearch.py --source=x --type=x --path=x\n" )
    print( "Sources: Any extension file" )
    print( " -s  or  --source=cxx        - Search in cxx files only" )
    print( " -s  or  --source=hxx        - Search in hxx files only" )
    print( " -s  or  --source=java       - Search in java files only" )
    print( " -s  or  --source=any        - Search in any file" )
    print( " PS: By now, valid extensions can be: any, c, h, cxx, hxx, java, mm\n" )
    print( "Types: Can be macro or method by now" )
    print( " -t  or  --type=macros       - Search for macros" )
    print( " -t  or  --type=classes      - Search for methods\n" )
    print( "Path: the path where you want looking for" )
    print( " PS 1: Works fine for relative or absolut path." )
    print( " PS 2: If no path was informed, current folder will be used instead.\n" )
    print( " -p  or  --path=$HOME        - Search from $HOME\n" )
    print( " -h  or  --help              - Show this message.\n" )
    sys.exit( 0 )
    


def removeEmpty( tList, tTerm ):
    newList = []
    for files in tList:
        nLines = countLinesOf( files )
        f = open(files, "r")

        for i in range( nLines ):
            lineBuffer = f.readline()
            if str(tTerm) in lineBuffer:
                newList.append( files )
                f.close()
                break

        f.close()
    return newList
   

def countLinesOf( tFile ):
    f = open(tFile, "r")
    count = 0
    while not not f.readline():
        count += 1
    f.close()
    return count


def getIndexOf( tTerm, tFile ):
    nLines = countLinesOf( tFile )
    f = open(tFile, "r")
    indexOfTerms = []
    for count in range( nLines ):
        result = f.readline()
        if str( tTerm ) in result:
            print( "Found: " + result ),
            indexOfTerms.append( count + 1 )
    return indexOfTerms



'''
    script begin
'''
# validate the input parameters and inform a message
paramReceived = validParameters()
searchIn      = paramReceived[0]
searchFor     = paramReceived[1]
searchWhere   = paramReceived[2]
print( "Search in "  + str( searchIn )    + " files." )
print( "Search for " + str( searchFor ) )
print( "Search in "  + str( searchWhere ) + " folder.\n" )

print( "Press <enter> to start ... " )
os.system( "read b" )

# correction of term searchIn
if searchIn == "any":
    searchIn = "*.*"
else:
    searchIn = "*." + searchIn

# create a list with all files of the extension required
fullList = createList( searchWhere, searchIn )

# if list is empty, stop and finish the program
if not len( fullList ):
    print( " No files found!" )
    toStop = True
else:
    toStop = False


if searchFor == "macros" and not toStop:
    # remove files which don't have #defines
    newList = removeEmpty( fullList, "#define" )

    # print the file and the respective #define
    for eachFile in newList:
        os.system( "clear" )
        print( "File: " + str( eachFile ) )
        indexList = getIndexOf( "#define", eachFile )

        print( "\n\nPress <enter> to continue.." )
        stErr = os.system( "read b" )

    print( "Done!" )

#elif searchFor == "classes" and not toStop:
    # remove files which don't have classes
    # newList = removeEmpty(fullList, searchFor)
