#!/usr/bin/python
#

#
# print a message
#

import os, sys, getopt

cmdlist = "help src=".split()

# Check for correctness of the entered command line arguments

exiterror = 0

try:
    opts, args = getopt.getopt(sys.argv[1:],'',cmdlist)
except getopt.GetoptError as err:
    print str(err)
    exiterror = 1

os.system('clear')

srcfile = ""

try:
	if len(args) :
		print "\nCOMMAND ERROR : Non recogonizable commands / options present in command line"
		exiterror = 1
except NameError :
		exiterror = 1	
    
if exiterror == 1 :

     print "\nCorrect Usage of Program indicated below\n\n"
	
     print "./sxrASM.py --src='source file name'\n"

     sys.exit()

for o,a in opts :

     if "help" in o :
          print "\sxrASM.py - Assembler for 14 bit Harvard RISC Processor sxrRISC621."

	  print "\nCorrect Usage of Program indicated below\n"
	
	  print "./sxrASM.py --src='source file name'\n"

          sys.exit()

     if "src" in o :
	     if srcfile == "" :
		     srcfile = a 
	     else :
		     print "\nCOMMAND ERROR : Multiple Parameter file specifications detected" 
		     exiterror = 1 

if exiterror :

     print "\nCorrect Usage of Program indicated below\n\n"
	
     print "./sxrASM.py --src='source file name'\n"

     sys.exit()

# Check for the right combination of parameters

if (srcfile == "") :
		print "\nARGUMENT ERROR : Necessary options not specified (stages,width,reset value, output filename are mandatory)" 
		exiterror = 1 

if exiterror :

     print "\nCorrect Usage of Program indicated below\n\n"
	
     print "./sxrASM.py --src='source file name'\n"

     sys.exit()		

# Read parameter options from specified param file

if (srcfile != ""):

     try :

          with open(param, 'r') as f :

               for o in f :
               
               	words = o.split()
               	
               	endcommand = 0
               
               	for word in words :
               		
               		if ';' in word :
               			
               			endcommand = 1;
               		
               		

     except IOError as e:

          print "\nI/O error({0}): {1}".format(e.errno, e.strerror)

          exiterror = 1

if exiterror :

     print "\nCorrect Usage of Program indicated below\n\n"
	
     print "./sxrASM.py --src='source file name'\n"

     sys.exit()
