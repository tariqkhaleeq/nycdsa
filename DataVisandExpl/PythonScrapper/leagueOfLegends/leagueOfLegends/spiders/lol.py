# -*- coding: utf-8 -*-
from scrapy import Spider
from leagueOfLegends.items import LOLItem
from scrapy.selector import Selector

class LolSpider(Spider):
    name = "lol"
    allowed_domains = ["https://lol.garena.com/champions"]
    start_urls = ['http://www.lolking.net/guides/']

    def parse(self, response):
        rows = response.xpath('//*[@id="guides-champion-list"]/a').extract()

        for row in rows:
            name = Selector(text=row).xpath('//div[2]/text()').extract()
            poporstr = ''
            if not (Selector(text=row).xpath('//div[2]/text()').extract()):
                name = Selector(text=row).xpath('//div[3]/text()').extract()
                poporstr = Selector(text=row).xpath('//div[1]/text()').extract()

            item = LOLItem()
            item['name'] = name
            item['poporstr'] = poporstr

            yield item
