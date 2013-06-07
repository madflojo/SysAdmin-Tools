#!/usr/bin/python
#### This script will take two directories from cmdline
#### and compare files that exist in both
#### --------------------------------------------------
#### Benjamin Cane - 06/04/2013

## Import Modules
import os, sys, filecmp, difflib

def compare_file(filename, outdir):
    file1 = dir1 + "/" + filename
    file2 = dir2 + "/" + filename
    f1 = open(file1, "r")
    f2 = open(file2, "r")
    text1 = f1.readlines(1)
    text2 = f2.readlines(2)
    path_file = outdir + "/" + filename
    outfile = open(path_file, "w")
    for output in difflib.context_diff(text1, text2, fromfile=file1, tofile=file2):
        outfile.write(output)
    f1.close()
    f2.close()
    outfile.close()

def create_out(path_file):
    path = "/".join(path_file.split("/")[:-1])
    if os.path.isdir(path) is False:
         os.makedirs(path)

## Gather cmdline vars
if len(sys.argv) != 4:
    print('Invalid Arguments: %s dir1 dir2 outdir') % str(sys.argv[0])
    sys.exit(2)

scriptname, dir1, dir2, outdir = sys.argv

if os.path.isdir(dir1) is True and os.path.isdir(dir2) is True:
    compare = filecmp.dircmp(dir1, dir2)
    difflist = compare.diff_files
    print("Output directory: %s") % outdir

    for file in difflist:
        print("%s is different") % file
        path_file = outdir + "/" + file
        create_out(path_file)
        compare_file(file, outdir)

else:
    print("Let's try again with valid directories?")
    print("One of your arguments was not a directory")
    sys.exit(2)
