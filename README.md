# lo_usefull

This repository contains tools for help LibreOffice development.

----

### find\_duplicate\_entries.py

Show all includes and _"using namespaces"_ entries that are duplicated in a _cxx_, hxx, c and in h file.

### find\_old\_string\_classes.sh

Show to us where are used the old strings classes, and these classes need to be replaced.

### find\_chained\_appends.sh

Shows where are used chained appends. This appends needs to be replaced by string concatenation, to be more fast in _C++_.

### find\_string\_comparison.sh

Shows where are used some methods for string comparison. These can be replaced by `==` operator. Much more simpler.

### find\_sal\_types.py

Show files that are using sal_uLong or/and sal_uIntPtr. These types must be converted to sal_uInt32, sal_uInt64, size_t or "unsigned int" according to situation.

### get\_developers\_score.sh

Show how many lines of code a developer has inserted, has changed, and how much commit he did. 

##### Manteiner: Marcos Paulo de Souza

### pre-install.sh

Installs all necessary dependencies for compile and build LO, and download the LO code using git.

##### Manteiner: Ricardo Montania

### unusedCodeSearch.sh

A script who actually find these types of unused codes: unused macros dead ifdefs - without defines. This is script will grow ASAP, while we make new checkers. 

##### Manteiners: Ricardo Montania & Marcos Paulo de Souza

### todo_unusedCode.txt

Things that need to be done in the _unusedCodeSearch.sh_
