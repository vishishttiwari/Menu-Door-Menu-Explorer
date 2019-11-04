#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sat Jun  8 22:59:00 2019

@author: vishishttiwari
"""
import os
import operator

path = "/Users/vishishttiwari/Desktop/Crawl_DoorDash/Cuisines/"
path1 = "/Users/vishishttiwari/Desktop/Crawl_DoorDash/"

khanaMap = dict()

def sortDictionary(d):
    sorted_d = sorted(d.items(), key=operator.itemgetter(1))
    return sorted_d

def appendToFile1(word):
    newFile = path1 + 'WordsFrequency.csv'
    with open(newFile, 'a') as f:
        newWord = '\"' + word + '\", '
        f.write(newWord)

for r, d, f in os.walk(path):
    for fle in f:
        with open(path + fle,'r') as f:
            for line in f:
                for word in line.split():
                    if word in khanaMap.keys():
                        khanaMap[word] = khanaMap[word] + 1
                    else:
                        khanaMap[word] = 1
                
khana = sortDictionary(khanaMap)


khann= []
for khan in khana:
    khann.append(khan[0])

khann.reverse()

for khan in khann:
    if (len(khan) > 2) and khan.isalpha():
        appendToFile1(khan)