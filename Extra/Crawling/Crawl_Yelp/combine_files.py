#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import os
import operator
import re

path = os.path.dirname(os.path.abspath(__file__))
khanaMap = dict()
regex = re.compile('[@_!#$%^&*()<>?/\|}{~:]')
h = {'#', '%', '&', '(', ''}
savingFile = 'combinedWords1'

def checkSpecialCharacters(word):
    if '@' in word:
        return False
    if '#' in word:
        return False
    if '%' in word:
        return False
    if '&' in word:
        return False
    if '*' in word:
        return False
    if '(' in word:
        return False
    if ')' in word:
        return False
    if '^' in word:
        return False
    if '.' in word:
        return False
    if '0' in word:
        return False
    if '1' in word:
        return False
    if '2' in word:
        return False
    if '3' in word:
        return False
    if '4' in word:
        return False
    if '5' in word:
        return False
    if '6' in word:
        return False
    if '7' in word:
        return False
    if '8' in word:
        return False
    if '9' in word:
        return False
    if len(word) < 4:
        return False
    return True

def readFile(fileName):
    newFile = path + '/' + fileName + '.csv'
    with open(newFile) as f:
        contents = f.readlines()
        for i,content in enumerate(contents):
            if (i%1000 == 0):
                print(i)
            content = content.replace(',', '')
            content = content.replace('\n', '')
            words = content.split(' ')
            for word in words:
                if checkSpecialCharacters(word):
                    if word in khanaMap.keys():
                        khanaMap[word] = khanaMap[word] + 1
                    else:
                        khanaMap[word] = 1
    
def writeFile(fileName):
    newFile = path + '/' + fileName + '.csv'
    f = open(newFile, 'w')
    f.close()

def appendToFile(fileName, word, number):
    newFile = path + '/' + fileName + '.csv'
    with open(newFile, 'a') as f:
        newWord = word.capitalize() + ',' + str(number) + '\n'
        f.write(newWord)
        
def appendToFile1(fileName, word):
    newFile = path + '/' + fileName + '.csv'
    with open(newFile, 'a') as f:
        newWord = '"' + word.capitalize() + '",'
        f.write(newWord)
        
def sortDictionary(d):
    sorted_d = sorted(d.items(), key=operator.itemgetter(1))
    return sorted_d

files = ['Brazilian', 'Chinese', 'French', 'Greek', 'Indian', 'Indian_Italian_etc', 'Indian2', 'Japanese', 'Japanese1', 'Korean', 'Lebanese', 'Mediterranean', 'Mexican', 'Thai', 'Vietnamese']

for f in files:
    print('Working in: ' + f)
    readFile(f)

writeFile(savingFile)
khanaMap = sortDictionary(khanaMap)

for khana in khanaMap:
    appendToFile1(savingFile, khana[0])
    
