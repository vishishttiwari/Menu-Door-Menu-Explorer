#!/usr/bin/env python2
# -*- coding: utf-8 -*-

from HTMLParser import HTMLParser
from Files import Files
import urllib
import sys
reload(sys)
sys.setdefaultencoding('utf8')

class LinkFinder(HTMLParser):
    def __init__(self, restaurants):
        HTMLParser.__init__(self)
        self.recording = 0
        
        restaurantLink = Files.readFile(restaurants)
        print('\nGoing through website: ' + restaurantLink.replace('\n', ''))
        url = urllib.urlopen(restaurantLink)
        html = url.read()
        self.feed(html)
        
    def error(self, message):
        pass
    
    def handle_starttag(self, tag, attr):
        if tag == 'div':
            for name, value in attr:
                if name == 'class' and value == 'media-title clearfix':
                    self.recording = 1
        if tag == 'a':
            for name, value in attr:
                if name == 'class' and value == 'biz-name js-analytics-click':
                    self.recording = 2
                if name == 'href' and self.recording == 2:
                    Files.appendToRestaurantLink(Files.restaurantFileName, value)   
                    self.recording = 0