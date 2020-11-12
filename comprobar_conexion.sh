#!/bin/bash
while [ : ] ; do ping -c1 8.8.8.8 && break; 
done; 
espeak "internet reconnected"