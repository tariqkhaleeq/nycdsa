# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html


class LOLPipeline(object):
    def __init__(self):
        self.filename = "LOL_champs.txt"

    def open_spider(self, spider):
        self.file = open(self.filename,'wb')

    def close_spider(self, spider):
        self.file.close()

    def process_item(self, item, spider):
        if item['poporstr']=='':
            line = str(item['name'][0]) + '\n'
            self.file.write(line)
        else:
            line = str(item['name'][0]) + '\t'+ str(item['poporstr'][0]) +'\n'
            self.file.write(line)
        return item
