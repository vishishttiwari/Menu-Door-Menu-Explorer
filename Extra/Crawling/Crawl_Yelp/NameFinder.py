#!/usr/bin/env python2
# -*- coding: utf-8 -*-

from HTMLParser import HTMLParser
from Files import Files
import urllib
import sys
reload(sys)
sys.setdefaultencoding('utf8')

class NameFinder(HTMLParser):
    def __init__(self, restaurants):
        HTMLParser.__init__(self)
        self.recording = 0
        
        restaurantLink = Files.readFile(restaurants)
        print('Going through website: ' + restaurantLink)
        url = urllib.urlopen(restaurantLink)
        html = url.read()
        self.feed(html)
        
    def error(self, message):
        pass
    
    def handle_starttag(self, tag, attr):
        if tag == 'h1':
            if self.recording == 0:
                for name, value in attr:
                    if name == 'class' and value == 'biz-page title embossed-text-white':
                        self.recording = 1
            
    def handle_data(self, data):
        if (self.recording == 1):
            print(data)