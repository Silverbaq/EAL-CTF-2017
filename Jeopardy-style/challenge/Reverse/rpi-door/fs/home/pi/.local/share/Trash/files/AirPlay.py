#!/bin/python
import subprocess
print "-"
print "Welcome to Roland's AirPlay Server"
print "##################################"
print "##################################"
print "-"

proc = subprocess.Popen(['echo', name],stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
(out, err) = proc.communicate()

print "AirPlay server started..."
print "-"
print out

