#!/usr/bin/python
#
# print a message
#

import shutil
import sys
import os

outfile = "sxrRISC621_ram.mif"

rommif = open(outfile,'w')

rommif.write("WIDTH=14;\n\nDEPTH=16384;\n\nADDRESS_RADIX=DEC;\n\nDATA_RADIX=HEX;\n\nCONTENT BEGIN\n")

rommif.write("\n\t" + str(0) + "\t:\t" + "0040" + "; % Loop Counter %")

rommif.write("\n\t" + str(1) + "\t:\t" + "1020" + "; % Case Change Offset %")

mifline = 16

for i in range(64):
    rommif.write("\n\t" + str(mifline) + "\t:\t" +
        str(hex(int(str('{0:07b}'.format(65 + (i % 26))) + str('{0:07b}'.format(65 + ((i + 1) % 26))),2))) + ";")

    mifline = mifline + 1;

    rommif.write("\n\t" + str(mifline) + "\t:\t" +
        str(hex(int(str('{0:07b}'.format(97 + (i % 26))) + str('{0:07b}'.format(97 + ((i + 1) % 26))),2))) + ";")

    mifline = mifline + 1;

    rommif.write("\n\t" + str(mifline) + "\t:\t" +
        str(hex(int(str('{0:07b}'.format(48 + (i % 10))) + str('{0:07b}'.format(48 + ((i + 1) % 10))),2))) + ";")

    mifline = mifline + 1;

    rommif.write("\n\t" + str(mifline) + "\t:\t"+
        str(hex(int(str('{0:07b}'.format(44)) + str('{0:07b}'.format(32)),2))) + ";")

    mifline = mifline + 1;

rommif.write("\n\nEND;")

rommif.close()