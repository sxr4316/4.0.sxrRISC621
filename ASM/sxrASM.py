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

sectionname 	= ""

sectionactive	= 0

if (srcfile != ""):

     try :

          with open(srcfile, 'r') as f :
          
          	line = 0;

                for o in f :
               
		       	line = line + 1
		       
		       	temp = o.replace(";"," ; ")
		       	
		       	words = temp.split()
		       	
		       	endcommand = 0
		       
		       	for word in words :
		       		
		       		if ';' in word :
		       			
		       			endcommand = 1;

		       		if (endcommand == 0) and ("." in word):
		       		
		       			if (".end" in word) and (sectionname in word) :

		       				currfile.write(word+" ")
		       			
		       				sectionactive = 0
		       				
		       				currfile.close()
		       				
		       			elif ("." in word) and (sectionactive == 0):
		       				
		       				sectionname = word.replace(".","")
		       				
		       				sectionactive = 1
		       				
		       				currfile = open(sectionname+".temp","w")
		       				
		       			elif ".equ" not in word and ".word" not in word:
		       			
		       				print "Illegal section definition @"+str(line)+" : "+str(o)
		       				
		       				
		       		if (endcommand == 0) and (sectionactive == 1) :
		       				
		       				
		       				currfile.write(word+" ");
		       				
		       	if (sectionactive == 1) :
		       	
		    		currfile.write("\n");

     except IOError as e:

          print "\nI/O error({0}): {1}".format(e.errno, e.strerror)

	  sys.exit()

knownwords = {""}
	  
for Files in os.listdir("./") :
	
	if Files.endswith(".temp") :
	
		print Files
		
		os.remove(Files)

