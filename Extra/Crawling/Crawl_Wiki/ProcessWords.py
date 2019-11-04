#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sat Jun  8 17:34:31 2019

@author: vishishttiwari
"""

import sys
reload(sys)
sys.setdefaultencoding('utf8')

class ProcessWords:
    def removeDigits(self, dish):
        return ''.join([i for i in dish if not i.isdigit()])
    
    def removeAllBrackets(self, dish):
        ret = ''
        skip1c = 0
        skip2c = 0
        skip3c = 0
        skip4c = 0
        for i in dish:
            if i == '[':
                skip1c += 1
            elif i == '(':
                skip2c += 1
            elif i == '{':
                skip3c += 1
            elif i == '<':
                skip4c += 1
            elif i == ']' and skip1c > 0:
                skip1c -= 1
            elif i == ')'and skip2c > 0:
                skip2c -= 1
            elif i == '}' and skip3c > 0:
                skip3c -= 1
            elif i == '>'and skip4c > 0:
                skip4c -= 1
            elif skip1c == 0 and skip2c == 0 and skip3c == 0 and skip4c == 0:
                ret += i
        return ret
    
    def specialCharacters(self, dish):
        dish1 = dish.replace("!", " ")
        dish = dish1.replace("@", " ")
        dish1 = dish.replace("#", " ")
        dish = dish1.replace("$", " ")
        dish1 = dish.replace("%", " ")
        dish = dish1.replace("^", " ")
        dish1 = dish.replace("&", " ")
        dish = dish1.replace("*", " ")
        dish1 = dish.replace("-", " ")
        dish = dish1.replace("_", " ")
        dish1 = dish.replace("=", " ")
        dish = dish1.replace("+", " ")
        dish1 = dish.replace("\\", " ")
        dish = dish1.replace("|", " ")
        dish1 = dish.replace(";", " ")
        dish = dish1.replace(":", " ")
        dish1 = dish.replace("/", " ")
        dish = dish1.replace("?", " ")
        dish1 = dish.replace(".", " ")
        dish = dish1.replace(",", " ")
        dish1 = dish.replace("~", " ")
        dish = dish1.replace(".", " ")
        dish1 = dish.replace("\'", " ")
        dish = dish1.replace("\"", " ")
        
        return dish
        
    def lowerCase(self, dish):
        return dish.lower()
    
    def spaces(self, dish):
        return " ".join(dish.split())
    
    def processItem(self, dish):
        dish1 = self.removeDigits(dish)
        dish2 = self.removeAllBrackets(dish1)
        dish3 = self.specialCharacters(dish2)
        dish4 = self.lowerCase(dish3)
        dish5 = self.spaces(dish4)
        
        return dish5