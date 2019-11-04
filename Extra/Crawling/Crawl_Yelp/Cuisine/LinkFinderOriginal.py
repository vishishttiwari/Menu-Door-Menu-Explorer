#!/usr/bin/env python2
# -*- coding: utf-8 -*-


from HTMLParser import HTMLParser
import urllib
import sys
reload(sys)
sys.setdefaultencoding('utf8')

class LinkFinder(HTMLParser):
    def __init__(self):
        HTMLParser.__init__(self)
        self.recording = 0
        
    def error(self, message):
        pass
    
    def handle_starttag(self, tag, attr):
        self.recording = 0
        if tag == 'div':
            for name, value in attr:
                if name == 'class' and value == 'media-title clearfix':
                    self.recording = 1
        if tag == 'a':
            for name, value in attr:
                if name == 'class' and value == 'biz-name js-analytics-click':
                    self.recording = 2
                if name == 'href' and self.recording == 2:
                    print(value)
                    
    def handle_endtag(self, tag):
        self.recording = 0
        
p = LinkFinder()
f = urllib.urlopen('https://www.yelp.com/biz/arusuvai-cafe-santa-clara-6')
html = f.read()
p.feed(html)
p.close()