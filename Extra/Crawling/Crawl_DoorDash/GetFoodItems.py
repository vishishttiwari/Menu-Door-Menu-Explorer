#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sat Jun  8 16:56:53 2019

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
path1 = "/Users/vishishttiwari/Desktop/Crawl_DoorDash/Cuisines/"
initalLink = "https://www.grubhub.com/search?orderMethod=delivery&locationMode=DELIVERY&facetSet=umamiV2&pageSize=20&hideHateos=true&searchMetrics=true&queryText=dosa&latitude=37.77492904&longitude=-122.41941834&sortSetId=umamiV2&sponsoredSize=3&countOmittingTimes=true"
restaurantType = "Indian" + ".csv"

# Set the driver for google chrome
chrome_path = path + "chromedriver"
driver = webdriver.Chrome(chrome_path)

# Create a file and append to it
def writeToFile(dish):
    if os.path.exists(path1 + restaurantType):
        append_write = 'a' # append if already exists
    else:
        append_write = 'w' # make a new file if not
    
    fle = open(path1 + restaurantType, append_write)
    fle.write(dish)

# Set link to get all restaurants
processWords = ProcessWords()
restaurantLinks = []
driver.get(initalLink)
time.sleep(2);
restaurants = driver.find_elements_by_class_name("restaurant-name")
for restaurant in restaurants:
    restaurantLinks.append(str(restaurant.get_attribute('href')))

# Create file for saving dishes
counter = 0
for link in restaurantLinks:
    counter += 1
    print(counter)
    
    driver.get(link)
    time.sleep(2);
    dishes = driver.find_elements_by_class_name("menuItemNew-name")
    for dish in dishes:
        dish1 = processWords.processItem(dish.text)
        writeToFile(dish1 + "\n")