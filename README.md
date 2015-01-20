Skynet
============================================
Semantic Web Crawler built in Rails using Mechanize, Nokogiri, Rmagick and Sidekiq

Need to install Image Magick

$ sudo apt-get install imagemagick libmagickwand-dev redis-server firefox xvfb

Trying something new

$ bundle exec rake crawl:scrimper[example.com]

Connect to API

$ curl http://localhost/ -H 'Authorization: Token token="32 bit key"'

or by visiting

http://localhost/?access_token=32 bit key
