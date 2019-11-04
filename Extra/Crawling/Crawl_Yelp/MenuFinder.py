#!/usr/bin/env python2
# -*- coding: utf-8 -*-

from HTMLParser import HTMLParser
from Files import Files
import urllib
import sys
reload(sys)
sys.setdefaultencoding('utf8')

class MenuFinder(HTMLParser):
    
    found = False
    
    def __init__(self, restaurants):
        HTMLParser.__init__(self)
        self.recording = 0
        self.found = False
        
        restaurantLink = Files.readFile(restaurants)
        restaurantLink = restaurantLink.replace('https://www.yelp.com/biz/', 'https://www.yelp.com/menu/')
        url = urllib.urlopen(restaurantLink)
        html = url.read()
        self.feed(html)
        
    def error(self, message):
        pass
    
    def handle_starttag(self, tag, attr):
        if tag == 'div':
            for name, value in attr:
                if name == 'class' and value == 'arrange_unit arrange_unit--fill menu-item-details':
                    self.recording = 1
        if tag == 'h4' and self.recording == 1:
            self.recording = 2
        if tag == 'a' and self.recording == 2:
            self.recording = 3
                    
    def handle_endtag(self, tag):
        if tag == 'div' or tag == 'a' or tag == 'h4':
            self.recording -= 1
            
    def handle_data(self, data):
        if (self.recording == 3):
            if (self.found == False):
                print('Menu Found')
                self.found = True
            Files.appendToDish(Files.dishFileName, data) 