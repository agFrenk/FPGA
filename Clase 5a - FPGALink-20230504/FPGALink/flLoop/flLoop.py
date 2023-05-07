#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import time
import fl
import argparse

print("FPGALink loop using python")
parser = argparse.ArgumentParser(prog='flLoop',
                                 description='Host side loop with FPGALink')
parser.add_argument('-b', '--board' ,
                    metavar="<board>", help="board: nexys2-500, atlys")                             
                                 
parser.add_argument('-i', '--ividpid' ,
                    metavar="<VID:PID>", help="initial vendor ID and product ID(e.g 04B4:8613)")                             
parser.add_argument('-v', '--vidpid' , default='1443:0005',
                    metavar="<VID:PID>", help="vendor ID and product ID (default 1443:0005 Nexys2)")
parser.add_argument('-x', '--xsvf',
                    metavar="<xsvf file>", help="device programming with XVSF file")
parser.add_argument('-j', '--justloop',action='store_true',
                    help="Solo probar el loop. No programar FPGA")
parser.add_argument('-o', '--output' , default='out.dat', 
                    metavar="<output file>", help="Output file (default out.dat)")
parser.add_argument('input',
                    metavar="<input file>", help="input file")
                    

args = parser.parse_args()

fl.flInitialise(0)
USBPower = False

if(args.board == "atlys"):
    args.vidpid = "1443:0007"
    args.ividpid = "1443:0007"

elif(args.board == "nexys2-500"):
    args.vidpid = "1443:0005"
    args.ividpid = "1443:0005"
    USBPower = True

print("Attempting to open connection to FPGALink device {}...".format(args.vidpid))
try:
    handle = fl.flOpen(args.vidpid)
except fl.FLException as ex:
    if(args.ividpid == None):
        print("Loading firmware into {}...".format(args.vidpid))
        fl.flLoadStandardFirmware(args.vidpid, args.vidpid)
    else:
        print("Loading firmware into {}...".format(args.ividpid))
        fl.flLoadStandardFirmware(args.vidpid, args.ividpid)  
        print("Awaiting renumeration...")        
    
    time.sleep(2)
    if(not fl.flIsDeviceAvailable(args.vidpid)):
        raise fl.FLException("FPGALink device did not renumerate properly as {}".format(args.vidpid))
        print("Attempting to open connection to FPGALink device {} again...".format(args.vidpid))    
    handle = fl.flOpen(args.vidpid)

if(not args.justloop):
    if USBPower:
        fl.flMultiBitPortAccess(handle, "D7+")

    if(args.xsvf != None):
        print("Programming FPGA con " + args.xsvf)
        fl.flProgram(handle, "J:D0D2D3D4:" + args.xsvf)

    fl.flSelectConduit(handle, 1)

time.sleep(1)
#Cargar archivo

print("Loading file...")

size_input_file = os.path.getsize(args.input)
print("Size of file " + args.input + ": " + str(size_input_file))

#Envio datos de a 32 bytes por rafaga

with open(args.output, 'wb') as outfile, open(args.input, 'rb',) as inFile:
    bytes = inFile.read(512)
    start = time.perf_counter()
    while len(bytes) != 0:
        fl.flWriteChannel(handle, 0x00, bytearray(bytes))
        bytes_readed = fl.flReadChannel(handle, 0x00, len(bytes))
        outfile.write(bytes_readed)
        bytes = inFile.read(512)
    stop = time.perf_counter()

    print("Elapsed time: {0} s [{1:.2f} MB/s]".format(stop-start, (size_input_file)/((stop-start)*1024*1024)))
    
fl.flClose(handle)
