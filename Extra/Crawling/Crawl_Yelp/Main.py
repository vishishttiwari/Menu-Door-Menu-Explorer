#!/usr/bin/env python2
# -*- coding: utf-8 -*-

from LinkFinder import LinkFinder
from MenuFinder import MenuFinder
from Files import Files
import sys
reload(sys)
sys.setdefaultencoding('utf8')

class Main:
    
    def start(self):
        Files.startAgain(Files.restaurantFileName)
        while Files.restaurantNumber < 999999999:
            lf = LinkFinder(Files.restaurantFileName)
            lf.close()
            
            mf = MenuFinder(Files.restaurantFileName)
            mf.close()
            
            Files.nextLink()
            
            print('Total restaurants covered: ' + str(Files.restaurantNumber))
        
try:
    m = Main()
    m.start()
except: 
    print("This restaurant caused an error")
    pass