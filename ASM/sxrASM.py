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

sectionname  = ""

sectionactive = 0

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

      rommif = open(str(srcfile.replace("."," ")).split()[0]+".mif",'w')

      rommif.write("WIDTH=14;\n\nDEPTH=16384;\n\nADDRESS_RADIX=DEC;\n\nDATA_RADIX=HEX;\n\nCONTENT BEGIN\n")

      try :
         with open("code.temp", 'r') as srccode :

            for codes in srccode :

               temp = codes.replace(","," ")

               code = str(temp).split()

               asmline = asmline + 1

               ins = ""

               if len(code) > 0 :

                  for entry in open("keywords.lst",'r')  :

                     key , val , num =  entry.split()

                     if key in code[0] :

                        codevalid = 1 

                        if (int(num) == -1) :

                           try :
                              if code[1] != "" :

                                 print "error : Unnecessary argument specified for "+key+" @"+str(asmline)+" : "+codes

                                 sys.exit()

                              else :
                              
                                 ins = str(val) + "00"

                           except IndexError:
               
                              ins = str(val) + "00"

                        if (int(num) == 0) :

                           try:
                           
                              if("R" in code[1]) :
   
                                 ins = str(val)+str(int(code[1].replace("R","")))+"0"
               
                              else :

                                 print "error : Invalid First Argument @"+str(asmline)+" : "+codes

                                 sys.exit()

                           except IndexError :

                                 print "error : Missing First Argument @"+str(asmline)+" : "+codes

                                 sys.exit()

                           except ValueError :

                              try : 
                                  
                                  if("R" in code[1]) :
   
                                    ins = str(val)+str(hex(code[1].replace("R","")))+"0"

                              except ValueError:

                                 print "error : Invalid First Argument @"+str(asmline)+" : "+codes

                                 sys.exit()

                              except IndexError :

                                 print "error : Missing First Argument @"+str(asmline)+" : "+codes

                                 sys.exit()

                           
                           try : 
                              if code[2] != "" :

                                 print "error : Unnecessary argument specified @"+str(asmline)+" : "+codes

                                 sys.exit()

                           except IndexError :
                  
                                   pass


                        if (int(num) == 1) :

                           try:
                           
                              if("R" in code[1]) :
   
                                 ins = str(val)+str( hex( int( code[1].replace("R","") ) ) ).replace("0x","")

                              else :

                                 print "error : Invalid First Argument @"+str(asmline)+" : "+codes

                                 sys.exit()

                           except IndexError :

                                 print "error : Missing First & Second Argument @"+str(asmline)+" : "+codes

                                 sys.exit()

                           except ValueError :

                              try : 
                                  
                                  if("R" in code[1]) :
   
                                     ins = str(val)+str( hex( int( code[1].replace("R","").replace("0x",""),16 ) ).replace("0x","") )

                                  else :

                                     print "error : Invalid First Argument @"+str(asmline)+" : "+codes

                                     sys.exit()

                              except IndexError :

                                 print "error : Missing First & Second Argument @"+str(asmline)+" : "+codes

                                 sys.exit()

                              except ValueError :

                                 print "error : Invalid First Argument @"+str(asmline)+" : "+codes

                                 sys.exit()
                           
                           try:
                           
                              if ( int(code[2]) < 17 and int(code[2]) >= 0) :
   
                                 ins = str(ins) + str( hex( int(code[2]) ) ).replace("0x","")
                        
                              else :

                                 print "error : Out of Range Second Argument @" + str(asmline) + " : "+codes

                                 sys.exit()         

                           except IndexError :

                                 print "error : Missing Second Argument @"+str(asmline)+" : "+codes

                                 sys.exit()

                           except ValueError :

                              try : 
                                  
                                 if(int(code[2].replace("0x",""),16)<17 and int(code[2].replace("0x",""),16)>=0) :
   
                                     ins = str(ins) + str( hex( int( code[2].replace("0x",""),16 ) ) ).replace("0x","")

                                 else :

                                    print "error : Out of Range Second Argument @"+str(asmline)+" : "+codes

                                    sys.exit() 

                              except IndexError :

                                 print "error : Missing Second Argument @"+str(asmline)+" : "+codes

                                 sys.exit()

                              except ValueError :

                                 print "error : Invalid Second Argument @"+str(asmline)+" : "+codes
   
                                 sys.exit()

                        if (int(num) == 2) :

                           try:
                           
                              if("R" in code[1]) :
   
                                 ins = str(val)+str( hex( int( code[1].replace("R","") ) ) ).replace("0x","")

                              else :

                                 print "error : Invalid First Argument @"+str(asmline)+" : "+codes

                                 sys.exit()


                           except IndexError :

                                 print "error : Missing First and Second Argument @"+str(asmline)+" : "+codes

                                 sys.exit()

                           except ValueError :

                              try : 
                                  
                                  if("R" in code[1]) :
   
                                     ins = str(val)+str( hex( int( code[1].replace("R","").replace("0x",""),16 ) ).replace("0x","") )
                              
                                  else :

                                     print "error : Invalid First Argument @"+str(asmline)+" : "+codes

                                     sys.exit()

                              except ValueError :

                                 print "error : Invalid First Argument @"+str(asmline)+" : "+codes

                                 sys.exit()
                           
                           try:
                           
                              if("R" in code[2]) :
   
                                 ins = str(ins)+str( hex( int( code[2].replace("R","") ) ) ).replace("0x","")

                              else :

                                  print "error : Invalid First Argument @"+str(asmline)+" : "+codes

                                  sys.exit()

                           except IndexError :

                                 print "error : Missing Second Argument @"+str(asmline)+" : "+codes

                                 sys.exit()

                           except ValueError :

                              try : 
                                  
                                  if("R" in code[2]) :
   
                                     ins = str(ins)+str( hex( int( code[2].replace("R","").replace("0x",""),16 ) ).replace("0x","") )
  
                                  else :

                                       print "error : Invalid First Argument @"+str(asmline)+" : "+codes

                                       sys.exit()
  
                              except IndexError:

                                 print "error : Missing Second Argument @"+str(asmline)+" : "+codes

                                 sys.exit()

                              except ValueError:

                                 print "error : Invalid Second Argument @"+str(asmline)+" : "+codes

                                 sys.exit()


                        if (ins != "") :

                            rommif.write("\n\t"+str(mifline)+"\t:\t"+str(ins))

                            mifline = mifline + 1

                        break

      except IOError as e:

         print "\nI/O error({0}): {1}".format(e.errno, e.strerror)

         sys.exit()

      rommif.write("\nEND;")

      rommif.close

for Files in os.listdir("./") :
 	
	if Files.endswith(".temp") :
 	
          os.remove(Files)

sys.exit()
