#!/usr/bin/python
#
# print a message
#

import getopt
import shutil
import sys
import os

cmdlist = "help src=".split()

# Check for correctness of the entered command line arguments

exiterror = 0

try:

    opts, args = getopt.getopt(sys.argv[1:], '', cmdlist)

except getopt.GetoptError as err:

    print str(err)

    sys.exit()

for Files in os.listdir("./"):

    if Files.endswith(".temp"):
        os.remove(Files)

os.system('clear')

srcfile = ""

try:

    if len(args):
        print "\nCOMMAND ERROR : Non recogonizable commands / options present in command line"

        exiterror = 1

except NameError:

    exiterror = 1

if exiterror == 1:
    print "\nCorrect Usage of Program indicated below\n\n"

    print "./sxrASM.py --src='source file name'\n"

    sys.exit()

for o, a in opts:

    if "help" in o:
        print "\sxrASM.py - Assembler for 14 bit Harvard RISC Processor sxrRISC621."

        print "\nCorrect Usage of Program indicated below\n"

        print "./sxrASM.py --src='source file name'\n"

        sys.exit()

    if "src" in o:

        if srcfile == "":

            srcfile = a

        else:

            print "\nCOMMAND ERROR : Multiple Parameter file specifications detected"

            exiterror = 1

if exiterror:
    print "\nCorrect Usage of Program indicated below\n\n"

    print "./sxrASM.py --src='source file name'\n"

    sys.exit()

# Check for the right combination of parameters

if srcfile == "":
    print "\nARGUMENT ERROR : Necessary options not specified (stages,width,reset value, output filename are mandatory)"

    exiterror = 1

if exiterror:
    print "\nCorrect Usage of Program indicated below\n\n"

    print "./sxrASM.py --src='source file name'\n"

    sys.exit()

# Read parameter options from specified param file

Valid = 0

sectionname = ""

sectionactive = 0

f = ""

try:

    keyfile = open("keywords.lst", 'r')

except IOError:

    keyfile = open("keywords.lst", 'w')

    keyfile.write("NOP    00    -1\n")
    keyfile.write("RET    12    -1\n")
    keyfile.write("NOT    28     0\n")
    keyfile.write("ADDC   22     1\n")
    keyfile.write("SUBC   23     1\n")
    keyfile.write("MULC   26     1\n")
    keyfile.write("DIVC   27     1\n")
    keyfile.write("SHLL   2C     1\n")
    keyfile.write("SHRL   2D     1\n")
    keyfile.write("SHLA   2E     1\n")
    keyfile.write("SHRA   2F     1\n")
    keyfile.write("ROTL   30     1\n")
    keyfile.write("ROTR   31     1\n")
    keyfile.write("RTLC   32     1\n")
    keyfile.write("RTRC   33     1\n")
    keyfile.write("CPY    03     2\n")
    keyfile.write("SWAP   04     2\n")
    keyfile.write("ADD    20     2\n")
    keyfile.write("SUB    21     2\n")
    keyfile.write("MUL    24     2\n")
    keyfile.write("DIV    25     2\n")
    keyfile.write("AND    29     2\n")
    keyfile.write("XOR    2B     2\n")
    keyfile.write("OR     2A     2\n")
    keyfile.write("CALL   1100   3\n")
    keyfile.write("JMPNZ  100E   3\n")
    keyfile.write("JMPNC  1007   3\n")
    keyfile.write("JMPNV  100D   3\n")
    keyfile.write("JMPNN  100B   3\n")
    keyfile.write("JMPZ   1001   3\n")
    keyfile.write("JMPC   1008   3\n")
    keyfile.write("JMPV   1002   3\n")
    keyfile.write("JMPN   1004   3\n")
    keyfile.write("JMP    1000   3\n")
    keyfile.write("LD     01     4\n")
    keyfile.write("ST     02     4\n")

    keyfile.close()

old = ""

new = ""

if srcfile != "":

    try:

        with open(srcfile, 'r') as f:

            line = 0

            for o in f:

                line += 1

                temp = o.replace(";", " ; ")

                words = temp.split()

                try:
                    if "@" not in words[0]:
                        new = words[0]
                    else:
                        new = words[1]
                except IndexError:
                    pass;

                EoC = 0

                Valid = 0

                for word in words:

                    if ';' in word:

                        EoC = 1

                    if (EoC == 0) and ("." in word):

                        if (".end" in word) and (sectionname in word):

                            sectionactive = 0

                            currfile.close()

                        elif ("." in word) and (sectionactive == 0):

                            sectionname = word.replace(".", "")

                            sectionactive = 1

                            currfile = open(sectionname + ".temp", "w")

                        elif (".equ" not in word) and (".word" not in word):

                            print "Illegal section definition @" + str(line) + " : " + str(o)

                    if (EoC == 0) and (sectionactive == 1) and ("." not in word):

                        if (old == "LD" or old == "ST") and (new == "CALL" or new == "RET"):

                            currfile.write("NOP;\n")

                            old = new

                        Valid = 1

                        currfile.write(word + " ")

                if (sectionactive == 1) and ("." not in word) and (Valid == 1):

                    currfile.write("\n")

                    old = new

    except IOError as e:

        print "\nI/O error({0}): {1}".format(e.errno, e.strerror)

        sys.exit()

labels = dict()

for Files in os.listdir("./"):

    if "code.temp" in Files:

        try:

            with open("code.temp", 'r') as srccode:

                Valid = 0

                asmline = 0

                mifline = 0

                for codes in srccode:

                    temp = codes.replace(",", " ")

                    code = str(temp).split()

                    asmline += 1

                    ins = ""

                    if '@' in code[0]:

                        if code[0] not in labels:

                            labels[code[0]] = str(hex(mifline)).replace("0x", "").upper()

                        else:

                            print "error : Multiple label declarations for " + code[0].replace('@', '') + " detected "

                            sys.exit()

                        index = 1

                    else:

                        index = 0

                    if len(code) > index:

                        for entry in open("keywords.lst", 'r'):

                            key, val, num = entry.split()

                            if key.upper() in code[index].upper():

                                if int(num) < 3:

                                    mifline += 1

                                else:

                                    mifline += 2

                                break
        except IOError as e:

            print "\nI/O error({0}): {1}".format(e.errno, e.strerror)

            sys.exit()

outfile = str(srcfile.replace(".", " ")).split()[0] + ".mif"

for Files in os.listdir("./"):

    if "code.temp" in Files:

        try:

            with open("code.temp", 'r') as srccode:

                asmline = 0

                mifline = 0

                rommif = open(str(srcfile.replace(".", " ")).split()[0] + ".mif", 'w')

                rommif.write("WIDTH=14;\n\nDEPTH=16384;\n\nADDRESS_RADIX=DEC;\n\nDATA_RADIX=HEX;\n\nCONTENT BEGIN\n")

                for codes in srccode:

                    temp = codes.replace(",", " ")

                    code = str(temp).split()

                    asmline += 1

                    Valid = 0

                    ins = ""

                    if '@' in code[0]:

                        index = 1

                    else:

                        index = 0

                    if len(code) > index:

                        for entry in open("keywords.lst", 'r'):

                            key, val, num = entry.split()

                            if key.upper() in code[index].upper():

                                Valid = 1

                                if int(num) == -1:

                                    try:
                                        if code[index + 1] != "":

                                            print "error : Unnecessary argument specified for " + key + " @" + str(
                                                asmline) + " : " + codes

                                            sys.exit()

                                        else:

                                            ins = str(val) + "00"

                                    except IndexError:

                                        ins = str(val) + "00"

                                if int(num) == 0:

                                    try:

                                        if "R" in code[index + 1]:

                                            ins = str(val) + str(int(code[index + 1].replace("R", ""))) + "0"

                                        else:

                                            print "error : Invalid First Argument @" + str(asmline) + " : " + codes

                                            sys.exit()

                                    except IndexError:

                                        print "error : Missing First Argument @" + str(asmline) + " : " + codes

                                        sys.exit()

                                    except ValueError:

                                        try:

                                            if "R" in code[index + 1]:
                                                ins = str(val) + str(hex(code[index + 1].replace("R", ""))).replace(
                                                    "0x", "") + "0"

                                        except ValueError:

                                            print "error : Invalid First Argument @" + str(asmline) + " : " + codes

                                            sys.exit()

                                        except IndexError:

                                            print "error : Missing First Argument @" + str(asmline) + " : " + codes

                                            sys.exit()

                                    try:
                                        if code[index + 2] != "":
                                            print "error : Unnecessary argument specified @" + str(
                                                asmline) + " : " + codes

                                            sys.exit()

                                    except IndexError:

                                        pass

                                if int(num) == 1:

                                    try:

                                        if "R" in code[index + 1]:

                                            ins = str(val) + str(hex(int(code[index + 1].replace("R", "")))).replace(
                                                "0x", "")

                                        else:

                                            print "error : Invalid First Argument @" + str(asmline) + " : " + codes

                                            sys.exit()

                                    except IndexError:

                                        print "error : Missing First & Second Argument @" + str(asmline) + " : " + codes

                                        sys.exit()

                                    except ValueError:

                                        try:

                                            if "R" in code[index + 1]:

                                                ins = str(val) + str(hex(
                                                    int(code[index + 1].replace("R", "").replace("0x", ""),
                                                        16)).replace("0x", ""))

                                            else:

                                                print "error : Invalid First Argument @" + str(asmline) + " : " + codes

                                                sys.exit()

                                        except IndexError:

                                            print "error : Missing First & Second Argument @" + str(
                                                asmline) + " : " + codes

                                            sys.exit()

                                        except ValueError:

                                            print "error : Invalid First Argument @" + str(asmline) + " : " + codes

                                            sys.exit()

                                    try:

                                        if 17 > int(code[index + 2]) >= 0:

                                            ins = str(ins) + str(hex(int(code[index + 2]))).replace("0x", "")

                                        else:

                                            print "error : Out of Range Second Argument @" + str(
                                                asmline) + " : " + codes

                                            sys.exit()

                                    except IndexError:

                                        print "error : Missing Second Argument @" + str(asmline) + " : " + codes

                                        sys.exit()

                                    except ValueError:

                                        try:

                                            if 17 > int(code[index + 2].replace("0x", ""), 16) >= 0:

                                                ins = str(ins) + str(
                                                    hex(int(code[index + 2].replace("0x", ""), 16))).replace("0x", "")

                                            else:

                                                print "error : Out of Range Second Argument @" + str(
                                                    asmline) + " : " + codes

                                                sys.exit()

                                        except IndexError:

                                            print "error : Missing Second Argument @" + str(asmline) + " : " + codes

                                            sys.exit()

                                        except ValueError:

                                            print "error : Invalid Second Argument @" + str(asmline) + " : " + codes

                                            sys.exit()

                                if int(num) == 2:

                                    try:

                                        if "R" in code[index + 1]:

                                            ins = str(val) + str(hex(int(code[index + 1].replace("R", "")))).replace(
                                                "0x", "")

                                        else:

                                            print "error : Invalid First Argument @" + str(asmline) + " : " + codes

                                            sys.exit()

                                    except IndexError:

                                        print "error : Missing First and Second Argument @" + str(
                                            asmline) + " : " + codes

                                        sys.exit()

                                    except ValueError:

                                        try:

                                            if "R" in code[index + 1]:

                                                ins = str(val) + str(
                                                    hex(int(code[index + 1].replace("R", "").replace("0x", ""),
                                                            16)).replace("0x", ""))

                                            else:

                                                print "error : Invalid First Argument @" + str(asmline) + " : " + codes

                                                sys.exit()

                                        except ValueError:

                                            print "error : Invalid First Argument @" + str(asmline) + " : " + codes

                                            sys.exit()

                                    try:

                                        if "R" in code[index + 2]:

                                            ins = str(ins) + str(hex(int(code[index + 2].replace("R", "")))).replace(
                                                "0x", "")

                                        else:

                                            print "error : Invalid First Argument @" + str(asmline) + " : " + codes

                                            sys.exit()

                                    except IndexError:

                                        print "error : Missing Second Argument @" + str(asmline) + " : " + codes

                                        sys.exit()

                                    except ValueError:

                                        try:

                                            if "R" in code[index + 2]:

                                                ins = str(ins) + str(hex(
                                                    int(code[index + 2].replace("R", "").replace("0x", ""),
                                                        16)).replace("0x", ""))

                                            else:

                                                print "error : Invalid First Argument @" + str(asmline) + " : " + codes

                                                sys.exit()

                                        except IndexError:

                                            print "error : Missing Second Argument @" + str(asmline) + " : " + codes

                                            sys.exit()

                                        except ValueError:

                                            print "error : Invalid Second Argument @" + str(asmline) + " : " + codes

                                            sys.exit()

                                if int(num) == 3:

                                    try:

                                        if "@" in code[index + 1]:

                                            if code[index + 1] in labels:

                                                rommif.write("\n\t" + str(mifline) + "\t:\t" + str(val) + ";")

                                                mifline += 1

                                                ins = ""

                                                ins = ins.join("0" * (4 - len(str(labels[code[index + 1]])))) + str(
                                                    labels[code[index + 1]])

                                            else:

                                                print "error : Undefined label used in @" + str(asmline) + " : " + codes

                                                sys.exit()

                                        else:

                                            print "error : Invalid Argument @" + str(asmline) + " : " + codes

                                            sys.exit()

                                    except IndexError:

                                        print "error : Missing First and Second Argument @" + str(
                                            asmline) + " : " + codes

                                        sys.exit()

                                if int(num) == 4:

                                    try:

                                        if "R" in code[index + 1]:

                                            Rj = str(
                                                hex(int(code[index + 1].replace("R", "")))).replace(
                                                "0x", "")

                                        else:

                                            print "error : Invalid First Argument @" + str(asmline) + " : " + codes

                                            sys.exit()

                                    except IndexError:

                                        print "error : Missing First & Second Argument @" + str(
                                            asmline) + " : " + codes

                                        sys.exit()

                                    except ValueError:

                                        try:

                                            if "R" in code[index + 1]:

                                                Rj = str(hex(
                                                    int(code[index + 1].replace("R", "").replace("0x", ""),
                                                        16)).replace("0x", ""))

                                            else:

                                                print "error : Invalid First Argument @" + str(
                                                    asmline) + " : " + codes

                                                sys.exit()

                                        except IndexError:

                                            print "error : Missing First & Second Argument @" + str(
                                                asmline) + " : " + codes

                                            sys.exit()

                                        except ValueError:

                                            print "error : Invalid First Argument @" + str(asmline) + " : " + codes

                                            sys.exit()

                                    args = "".join(code[(index + 2):]).replace(" ", "")

                                    code = args.replace("M[", "").replace("]", "").replace("+", " ").split()

                                    try:

                                        if "PC" in code[0]:

                                            Ri = str("1")

                                            ins = str(val) + str(Ri) + str(Rj)

                                            rommif.write("\n\t" + str(mifline) + "\t:\t" + str(
                                                ins) + ";" + "\t % " + codes.replace("\n", "") + + "\t % ")

                                            mifline += 1

                                            ins = ""

                                        elif "SP" in code[0]:

                                            Ri = str("2")

                                            ins = str(val) + str(Ri) + str(Rj)

                                            rommif.write("\n\t" + str(mifline) + "\t:\t" + str(
                                                ins) + ";" + "\t % " + codes.replace("\n", "") + "\t % ")

                                            mifline += 1

                                            ins = ""

                                        elif "R" in code[0] and (2 < int(code[0].replace("R", ""), 16) < 16):

                                            Ri = str(
                                                hex(int(code[0].replace("R", "")))).replace(
                                                "0x", "")

                                            ins = str(val) + str(Ri) + str(Rj)

                                            rommif.write("\n\t" + str(mifline) + "\t:\t" + str(
                                                ins) + ";" + "\t % " + codes.replace("\n", "") + "\t % ")

                                            mifline += 1

                                            ins = ""

                                        else:

                                            Ri = str("0")

                                            ins = str(val) + str(Ri) + str(Rj)

                                            rommif.write("\n\t" + str(mifline) + "\t:\t" + str(
                                                ins) + ";" + "\t % " + codes.replace("\n", "") + "\t % ")

                                            mifline += 1

                                            ins = ""

                                    except IndexError:

                                        print "error : Missing First & Second Memory Argument @" + str(
                                            asmline) + " : " + codes

                                        sys.exit()

                                    except ValueError:

                                        print "error : Invalid First Memory Argument @" + str(
                                            asmline) + " : " + codes

                                        sys.exit()

                                    try:

                                        if 16384 > int(code[1].replace("]", "")) >= 0:

                                            ins = str(ins) + str(hex(int(code[1].replace("]", "")))).replace("0x", "")

                                            ins = str("0") * (4 - len(str(ins))) + str(ins)

                                            rommif.write("\n\t" + str(mifline) + "\t:\t" + str(
                                                ins) + ";" + "\t % " + codes.replace("\n", "") + "\t % ")

                                            mifline += 1

                                            ins = ""

                                        else:

                                            print "error : Out of Range Second Argument @" + str(
                                                asmline) + " : " + codes

                                            sys.exit()

                                    except IndexError:

                                        print "error : Missing Second Argument @" + str(
                                            asmline) + " : " + codes

                                        sys.exit()

                                    except ValueError:

                                        try:

                                            if 16384 > int(code[1].replace("]", "").replace("0x", ""), 16) >= 0:

                                                ins = str(ins) + str(
                                                    hex(int(code[1].replace("]", "").replace("0x", ""),
                                                            16))).replace("0x", "")

                                                ins = str("0") * (4 - len(str(ins))) + str(ins)

                                                rommif.write("\n\t" + str(mifline) + "\t:\t" + str(
                                                    ins) + ";" + "\t % " + codes.replace("\n", "") + "\t % ")

                                                mifline += 1

                                                ins = ""

                                            else:

                                                print "error : Out of Range Second Argument @" + str(
                                                    asmline) + " : " + codes

                                                sys.exit()

                                        except IndexError:

                                            print "error : Missing Second Argument @" + str(
                                                asmline) + " : " + codes

                                            sys.exit()

                                        except ValueError:

                                            print "error : Invalid Second Argument @" + str(asmline) + " : " + codes

                                            sys.exit()

                                if (num != 3) and (num != 4) and (ins != ""):
                                    rommif.write(
                                        "\n\t" + str(mifline) + "\t:\t" + str(ins) + ";" + "\t % " + codes.replace("\n",
                                                                                                                   "") + "\t % ")

                                    mifline += 1

                                    ins = ""

                                break

                        if Valid == 0:
                            print "error : Unrecogonized ASM opcode @ " + str(asmline) + " : " + codes

                            sys.exit()

                rommif.write("\n\nEND;")

                rommif.close()

                shutil.copy(str(srcfile.replace(".", " ")).split()[0] + ".mif", "./../sxrRISC621_rom.mif")

        except IOError as e:

            print "\nI/O error({0}): {1}".format(e.errno, e.strerror)

            sys.exit()

for Files in os.listdir("./"):

    if Files.endswith(".temp"):
        #        os.remove(Files)
        pass;
print "Processing Complete \n Source Assembly File : " + srcfile + "\n Output MIF file : " + outfile + "\n"

sys.exit()
