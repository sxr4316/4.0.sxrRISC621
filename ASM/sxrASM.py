#!/usr/bin/python
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

validdata = 0

sectionname 	= ""

sectionactive	= 0

if (srcfile != ""):

     try :

          with open(srcfile, 'r') as f :

               line = 0

               for o in f :

                    line = line + 1

                    temp = o.replace(";"," ; ")

                    words = temp.split()

                    endcommand = 0

                    validdata = 0

                    for word in words :

                         if ';' in word :

                              endcommand = 1

                         if (endcommand == 0) and ("." in word):

                              if (".end" in word) and (sectionname in word) :

                                   sectionactive = 0

                                   currfile.close()

                              elif ("." in word) and (sectionactive == 0) :

                                   sectionname = word.replace(".","")

                                   sectionactive = 1

                                   currfile = open(sectionname+".temp","w")

                              elif (".equ" not in word) and (".word" not in word) :

                                   print "Illegal section definition @"+str(line)+" : "+str(o)


                         if ((endcommand == 0) and (sectionactive == 1) and ("." not in word)) :

                              validdata = 1

                              currfile.write(word+" ")

                    if (sectionactive == 1) and ("." not in word) and (validdata == 1):

                         currfile.write("\n");

     except IOError as e:

          print "\nI/O error({0}): {1}".format(e.errno, e.strerror)

          sys.exit()

for Files in os.listdir("./") :

     if "code.temp" in Files :

          asmline = 0

          mifline = 0

          rommif = open(str(srcfile.replace("."," ")).split()[1]+".mif",'w')

          rommif.write("WIDTH=14;\nDEPTH=16384;\nADDRESS_RADIX=DEC;\nDATA_RADIX=HEX;\nCONTENT BEGIN")

          try :
               with open("code.temp", 'r') as srccode :

                    for codes in srccode :

                         temp = codes.replace(","," ")

                         code = str(temp).split()

                         asmline = asmline + 1

                         if len(code) > 1 :

                              rommif.write("\n"+str(mifline)+"\t:\t")

                              mifline = mifline + 1

                         if len(code) > 0 :

                              for entry in open("keywords.lst",'r')  :

                                   key , val , num =  entry.split()

                                   if key in code[0] :

                                        ins = str(val)
                                        
                                        if (int(num) == -1) :

                                             if code[1] != "" :

                                                  print "error : Unnecessary argument specified @"+str(asmline)+" : "+codes

                                             sys.exit()

                                        if (int(num) == 0) :

                                             if("R" not in code[1] or code[1].replace("R",""))


                                        break;

          except IOError as e:

               print "\nI/O error({0}): {1}".format(e.errno, e.strerror)

               sys.exit()
