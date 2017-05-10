# WEB SCRAPPING WITH SCRAPY

This required using scrapy's spiders to scrap or extract from a website

Initially I wanted to start with extracting UFC fights and their stats. However when scrapping `fightmetric.com` I realized that the html code was terrible! I ended up shelving the idea for now and will visit it later.

I ended up focusing on a MMORPG game called League of Legends (LOL) and started extracting all the information available. LOL has a massive following and people have designed websites to help players build their champions. Mobafire is an example.

Using scrapy I was able to extract not only the champions bu also :
  - positions the champion is mostly played
  - win rate for those positions
  - pick rate for those positions
  - Mobas own metric to measure the champions:
    - damage
    - toughness
    - mobility
    - crowd control
    - utility

Extracting Moba's metric of champion measurement was tough because these were embedded in the CSS atrributes.

Hopefully, after this extraction building an app that can show how a champion can stack up against another champion might be interesting. 
