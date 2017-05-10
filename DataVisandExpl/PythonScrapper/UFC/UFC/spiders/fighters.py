# -*- coding: utf-8 -*-
from scrapy import Spider
from UFC.items import UfcItem
from scrapy.selector import Selector

class FightersSpider(Spider):
    name = "fighters"
    allowed_domains = ["www.fightmetric.com"]
    start_urls = ['http://www.fightmetric.com/statistics/fighters?char=a&page=all']

    def parse(self, response):
        rows = response.xpath('/html/body/section/div/div[2]/div/table/tbody/tr[2]').extract()
        for row in rows:
            first = Selector(text=row).xpath('//td[1]/a/text()').extract()
            last = Selector(text=row).xpath('//td[2]/a/text()').extract()
            nickname = Selector(text=row).xpath('//td[3]/a/text()').extract()
            #height = Selector(text=row).xpath('//td[4]/text()').extract()
            #weight = Selector(text=row).xpath('//td[5]/text()').extract()
            #reach = Selector(text=row).xpath('//td[6]/text()').extract()
            #stance = Selector(text=row).xpath('//td[7]/text()').extract()
            #win = Selector(text=row).xpath('//td[8]/text()').extract()
            #loss = Selector(text=row).xpath('//td[9]/text()').extract()
            #draw = Selector(text=row).xpath('//td[10]/text()').extract()
            #belt = Selector(text=row).xpath('//td[11]/text()').extract()

            item = UfcItem()
            item['first'] = first
            item['last'] = last
            item['nickname'] = nickname
            #item['height'] = height
            #item['weight'] = weight
            #item['reach'] = reach
            #item['stance'] = stance
            #item['win'] = win
            #item['loss'] = loss
            #item['draw'] = draw
            #item['belt'] = belt

            yield item
