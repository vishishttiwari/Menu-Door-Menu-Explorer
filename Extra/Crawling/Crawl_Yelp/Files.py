# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import os

class Files:
    
    restaurantNumber = 0
    restaurantSet = set()
    dishSet = set()
    path = os.path.dirname(os.path.abspath(__file__))
    dishFileName = "Indian"
    restaurantFileName = "restaurants" + dishFileName
    
    @staticmethod
    def startAgain(fileName):
        firstRestaurant = 'https://www.yelp.com/biz/the-yellow-chilli-by-sanjeev-kapoor-santa-clara-2'
        newFile = Files.path + '/' + fileName + '.csv'
        f = open(newFile, 'w')
        Files.appendToFile(fileName, firstRestaurant)
        Files.restaurantSet.add(firstRestaurant)
        f.close()
        
        newFile1 = Files.path + '/' + Files.dishFileName + '.csv'
        f1 = open(newFile1, 'w')
        f1.close()
        
    @staticmethod
    def writeFile(fileName):
        newFile = Files.path + '/' + fileName + '.csv'
        f = open(newFile, 'w')
        f.close()

    @staticmethod
    def appendToFile(fileName, link):
        if link not in Files.restaurantSet:
            Files.restaurantSet.add(link)
            newFile = Files.path + '/' + fileName + '.csv'
            with open(newFile, 'a') as f:
                f.write(link)

    @staticmethod
    def appendToDish(fileName, dish):
        if dish not in Files.dishSet:
            Files.dishSet.add(dish)
            newFile = Files.path + '/' + fileName + '.csv'
            with open(newFile, 'a') as f:
                f.write(dish + '\n')

    @staticmethod
    def appendToRestaurantLink(fileName, link):
        if 'https://www.yelp.com' not in link:
            newLink = 'https://www.yelp.com' + link
        else:
            newLink = link
        newLink = newLink.replace('?page_src=related_bizes', '')
        if newLink not in Files.restaurantSet:
            Files.restaurantSet.add(newLink)
            newFile = Files.path + '/' + fileName + '.csv'
            with open(newFile, 'a') as f:
                f.write('\n' + newLink)
    
    @staticmethod
    def readFile(fileName):
        newFile = Files.path + '/' + fileName + '.csv'
        newRestaurantLink = ""
        with open(newFile) as f:
            content = f.readlines()
            newRestaurantLink = content[Files.restaurantNumber].split(',')[0]
        return newRestaurantLink

    @staticmethod    
    def nextLink():
        Files.restaurantNumber += 1