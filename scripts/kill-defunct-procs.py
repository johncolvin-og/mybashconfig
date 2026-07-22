#!/usr/bin/python

import os
import re 
import sys
import subprocess

# Find defunct processes and save them to temporary file

if __name__ == "__main__":
    if len(sys.argv) > 1:
        a = sys.argv[1]
        if (a == "-l" or a == "--list" or a == "--dry" or a == "--dry-run"):
            subprocess.run("ps -ef | grep defunct", shell=True)
            exit()
    subprocess.run("ps -ef | grep defunct > zombies.txt", shell=True)

    pids = []

    # Load data from defunct processes file and remove the file
    zombies = open("zombies.txt", "r").read()
    subprocess.run("rm zombies.txt", shell=True)

    print(zombies)

    # For each zombie process, find the integers correspoding to the PID and PPID
    for z in zombies.split(" "):
        ints = re.findall(r'^[-+]?([1-9]\d*|0)$',z)
        if len(ints)==1:
            pids.append(ints[0])

    # There should be 3 integers per process
    assert len(pids)%3==0

    # Kill process by PID and PPID
    for i in range(len(pids)//3):
        print ("kill -9 "+pids[3*i]+" "+pids[3*i+1])
        subprocess.run("kill -9 "+pids[3*i]+" "+pids[3*i+1], shell=True)
        # os.system("kill -9 "+pids[3*i]+" "+pids[3*i+1])
