#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sat Jun  8 21:14:07 2019

@author: vishishttiwari
"""

from selenium import webdriver
import time
import os
from ProcessWords import ProcessWords
import sys
reload(sys)
sys.setdefaultencoding('utf8')

path = "/Users/vishishttiwari/Desktop/Crawl_DoorDash/"
initialLink = "https://en.wikipedia.org/wiki/List_of_cheeses"
restaurantType = "Cheese" + ".csv"

# Set the driver for google chrome
chrome_path = path + "chromedriver"
driver = webdriver.Chrome(chrome_path)

# Create a file and append to it
def writeToFile(dish):
    if os.path.exists(path + restaurantType):
        append_write = 'a' # append if already exists
    else:
        append_write = 'w' # make a new file if not
    
    fle = open(path + restaurantType, append_write)
    fle.write(dish)

# Set link to get all restaurants
processWords = ProcessWords()

driver.get(initialLink)
time.sleep(2);


items = driver.find_elements_by_tag_name("td")
counter = 0
for item in items:
    if item.text == "Injera":
        counter += 1
    if item.text == "Saj bread":
        counter += 3
    item1 = processWords.processItem(item.text)
    if counter % 4 == 0:
        print(item1)
        writeToFile(item1 + "\n")
    counter += 1

#dishes = driver.find_elements_by_class_name("thumb tright")

"""
for dish in dishes:
    print(dish.text)
    items = dish.find_elements_by_tag_name("tr")
    for item in items:
        item1 = processWords.processItem(item.text)
        writeToFile(item1 + "\n")
        
"""