# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

from scrapy import Item, Field


class UfcItem(Item):
    # define the fields for your item here like:
    # name = scrapy.Field()
    first = Field()
    last = Field()
    nickname = Field()
    #height = Field()
    #weight = Field()
    #reach = Field()
    #stance = Field()
    #win = Field()
    #loss = Field()
    #draw = Field()
    #belt = Field()
