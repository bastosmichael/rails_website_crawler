Skynet
============================================
Semantic Web Crawler built in Rails using Mechanize, Nokogiri, Rmagick and Sidekiq

Need to install Image Magick

$ sudo apt-get install imagemagick libmagickwand-dev redis-server firefox xvfb

Trying something new

$ bundle exec rake crawl:scrimper[example.com]

# API V1

## Get Status in JSON

> Request example

```shell
curl "http://localhost:3000/v1"
  -H "Authorization: Token token=YOUR-ACCESS-TOKEN"
```

> The above command returns JSON structured like this:

```json
{
  "response": {
    "status": 200
  },
  "active": true,
  "api_usage_cap": 100000000,
  "api_last_used": "2015-02-24",
  "api_daily_usage": 17,
  "available": {
    "amazon-offers": "2.9M",
    "walmart-offers": "134.4K",
    "costco-offers": "83K",
    "target-offers": "38.4K"
    },
  "indexing": "180",
  "processing": "453.6K",
  "pending": "947.2M"
}
```

Check the status of your current api usage as well as available data sources to pull from.

### HTTP Request

`GET http://localhost:3000/v1`

### Query Parameters

Parameter | Required | Description
--------- | ------- | -----------
access_token | true | Access token used to authenticate

### Status Types

Status Type | Description
--------- | -----------
active | Api Key is still active
api_usage_cap | Max number of allowed api calls per day (can be unlimited)
api_last_used | Date of the last call your key made to our api
api_daily_usage | Total number of api calls made on api_last_used date
available | Name and total number of data containers available for you to research
indexing | Collected data being added to search
processing | Data still waiting to be processed
pending | Data still waiting to be added to processing





## Get Status in XML

> Request example

```shell
curl "http://localhost:3000/v1.xml"
  -H "Authorization: Token token=YOUR-ACCESS-TOKEN"
```

> The above command returns XML structured like this:

```xml
<hash>
  <response>
    <status type="integer">200</status>
  </response>
  <active type="boolean">true</active>
  <api-usage-cap type="integer">1000</api-usage-cap>
  <api-last-used>2015-02-24</api-last-used>
  <api-daily-usage type="integer">38</api-daily-usage>
  <available>
    <amazon-offers>2.9M</amazon-offers>
    <walmart-offers>135.9K</walmart-offers>
    <costco-offers>83K</costco-offers>
    <target-offers>38.4K</target-offers>
  </available>
  <indexing>63</indexing>
  <processing>453.3K</processing>
  <pending>947.2M</pending>
</hash>
```

Check the status of your current api usage as well as available data sources to pull from.

### HTTP Request

`GET http://localhost:3000/v1.xml`

### Query Parameters

Parameter | Required | Description
--------- | ------- | -----------
access_token | true | Access token used to authenticate

### Status Types

Status Type | Description
--------- | -----------
active | Api Key is still active
api_usage_cap | Max number of allowed api calls per day (can be unlimited)
api_last_used | Date of the last call your key made to our api
api_daily_usage | Total number of api calls made on api_last_used date
available | Name and total number of data containers available for you to research
indexing | Collected data being added to search
processing | Data still waiting to be processed
pending | Data still waiting to be added to processing




## Search Items in JSON

> Request example

```shell
curl "http://localhost:3000/v1/amazon-offers/search/chromecast"
  -H "Authorization: Token token=YOUR-ACCESS-TOKEN"
```

> The above command returns JSON structured like this:

```json
{
  "response": {
    "status": 200
  },
  "results": [
    {
      "id": "B00DR0PDNE",
      "name": "Google Chromecast HDMI Streaming Media Player",
      "container": "amazon-offers"
    }
  ]
}
```

Search Items based on a query or key word.

### HTTP Request

`GET http://localhost:3000/v1/:CONTAINER/search/:QUERY`

### Query Parameters

Parameter | Required | Description
--------- | ------- | -----------
access_token | true | Access token used to authenticate
:CONTAINER | true| The available container you are searching in
:QUERY | true | What you are searching for
fetch | false | Automatically crawl new data (default: true)
social | false | Automatically fetch new social data (default: false)

<aside class="notice">
You must replace `:CONTAINER` with the available container you are searching in and `:QUERY` with what you are searching for.
</aside>




## Search Items in XML

> Request example

```shell
curl "http://localhost:3000/v1/amazon-offers/search/chromecast.xml"
  -H "Authorization: Token token=YOUR-ACCESS-TOKEN"
```

> The above command returns XML structured like this:

```xml
<hash>
  <response>
    <status type="integer">200</status>
  </response>
  <results type="array">
    <result>
      <id>B00DR0PDNE</id>
      <name>Google Chromecast HDMI Streaming Media Player</name>
      <container>amazon-offers</container>
    </result>
  </results>
</hash>
```

Search Items based on a query or key word.

### HTTP Request

`GET http://localhost:3000/v1/:CONTAINER/search/:QUERY.xml`

### Query Parameters

Parameter | Required | Description
--------- | ------- | -----------
access_token | true | Access token used to authenticate
:CONTAINER | true| The available container you are searching in
:QUERY | true | What you are searching for
fetch | false | Automatically crawl new data (default: true)
social | false | Automatically fetch new social data (default: false)

<aside class="notice">
You must replace `:CONTAINER` with the available container you are searching in and `:QUERY` with what you are searching for.
</aside>




## Match Items in JSON

> Request example

```shell
curl "http://localhost:3000/v1/walmart-offers/match?model=86002596-01"
  -H "Authorization: Token token=YOUR-ACCESS-TOKEN"
```

> The above command returns JSON structured like this:

```json
{
  "response": {
    "status": 200
  },
  "results": [
    {
      "url": "http://www.walmart.com/ip/Google-Chromecast-HDMI-Streaming-Media-Player/33142918",
      "date": "2015-02-24",
      "open_graph": true,
      "type": "Offer",
      "id": "811571013579",
      "image": "http://i5.walmartimages.com/dfw/dce07b8c-cc82/k2-_6f892d53-39df-4687-adae-fd16b2656547.v4.jpg",
      "site_name": "Walmart.com",
      "schema_org": true,
      "tags": [
        "Google",
        "Chromecast",
        "HDMI",
        "Streaming",
        "Media",
        "Player",
        "Wal-mart",
        "Walmart.com"
      ],
      "name": "Google Chromecast HDMI Streaming Media Player",
      "ItemID": "811571013579",
      "screenshot": "811571013579/2015-02-23.jpg",
      "price": "30.07",
      "priceCurrency": "USD",
      "availability": "InStock",
      "title": "Media Streaming Players",
      "sku": "811571013579",
      "mpn": "86002596-01",
      "brand": "Google",
      "model": "86002596-01",
      "facebook_shares": 42,
      "google_shares": 47,
      "twitter_shares": 12,
      "pinterest_shares": 10,
      "stumbleupon_shares": 1,
      "total_shares": 112,
      "container": "walmart-offers"
    }
  ]
}
```

Match Items in a container based on a specific set of known parameters and values.

### HTTP Request

`GET http://localhost:3000/v1/:CONTAINER/match`

### Query Parameters

Parameter | Required | Description
--------- | ------- | -----------
access_token | true | Access token used to authenticate
:CONTAINER | true| The available container you are searching in
:QUERY | true | What you are searching for
results | false | Number of Results you want back (default: 1)
fetch | false | Automatically crawl new data (default: true)
social | false | Automatically fetch new social data (default: false)
url | false | Unique URL for Item
date | false | When data was last gathered
id | false | Unique ID for Item
tags | false | Tags associated with Item
name | false | Unique name of Item
description | false | Given description for Item
type | false | Item Type
image | false | Unique Item image
facebook_shares | false | Number of times Item has been shared on Facebook
google_shares | false | Number of times Item has been shared on Google Plus
twitter_shares | false | Number of times Item has been shared on Twitter
reddit_shares | false | Number of times Item has been shared on Reddit
linkedin_shares | false | Number of times Item has been shared on LinkedIn
pinterest_shares | false | Number of times Item has been shared on Pinterest
stumbleupon_shares | false | Number of times Item has been shared on StumbleUpon
total_shares | false | Number of times Item has been shared on Social Media

<aside class="notice">
You must replace `:CONTAINER` with the available container you are matching against.
</aside>




## Match Items in XML

> Request example

```shell
curl "http://localhost:3000/v1/walmart-offers/match.xml?mpn=86002596-01"
  -H "Authorization: Token token=YOUR-ACCESS-TOKEN"
```

> The above command returns XML structured like this:

```xml
<hash>
  <response>
    <status type="integer">200</status>
  </response>
  <results type="array">
    <result>
      <url>
      http://www.walmart.com/ip/Google-Chromecast-HDMI-Streaming-Media-Player/33142918
      </url>
      <date>2015-02-25</date>
      <open-graph type="boolean">true</open-graph>
      <type>Offer</type>
      <id>811571013579</id>
      <image>
      http://i5.walmartimages.com/dfw/dce07b8c-cc82/k2-_6f892d53-39df-4687-adae-fd16b2656547.v4.jpg
      </image>
      <site-name>Walmart.com</site-name>
      <schema-org type="boolean">true</schema-org>
      <tags type="array">
        <tag>Google</tag>
        <tag>Chromecast</tag>
        <tag>HDMI</tag>
        <tag>Streaming</tag>
        <tag>Media</tag>
        <tag>Player</tag>
        <tag>Wal-mart</tag>
        <tag>Walmart.com</tag>
      </tags>
      <name>Google Chromecast HDMI Streaming Media Player</name>
      <ItemID>811571013579</ItemID>
      <screenshot>811571013579/2015-02-23.jpg</screenshot>
      <price>30.07</price>
      <priceCurrency>USD</priceCurrency>
      <availability>InStock</availability>
      <title>Media Streaming Players</title>
      <sku>811571013579</sku>
      <mpn>86002596-01</mpn>
      <brand>Google</brand>
      <model>86002596-01</model>
      <facebook-shares type="integer">42</facebook-shares>
      <google-shares type="integer">47</google-shares>
      <twitter-shares type="integer">12</twitter-shares>
      <pinterest-shares type="integer">10</pinterest-shares>
      <stumbleupon-shares type="integer">1</stumbleupon-shares>
      <total-shares type="integer">112</total-shares>
      <container>walmart-offers</container>
    </result>
  </results>
</hash>
```

Match Items in a container based on a specific set of known parameters and values.

### HTTP Request

`GET http://localhost:3000/v1/:CONTAINER/match.xml`

### Query Parameters

Parameter | Required | Description
--------- | ------- | -----------
access_token | true | Access token used to authenticate
:CONTAINER | true| The available container you are searching in
:QUERY | true | What you are searching for
results | false | Number of Results you want back (default: 1)
fetch | false | Automatically crawl new data (default: true)
social | false | Automatically fetch new social data (default: false)
url | false | Unique URL for Item
date | false | When data was last gathered
id | false | Unique ID for Item
tags | false | Tags associated with Item
name | false | Unique name of Item
description | false | Given description for Item
type | false | Item Type
image | false | Unique Item image
facebook_shares | false | Number of times Item has been shared on Facebook
google_shares | false | Number of times Item has been shared on Google Plus
twitter_shares | false | Number of times Item has been shared on Twitter
reddit_shares | false | Number of times Item has been shared on Reddit
linkedin_shares | false | Number of times Item has been shared on LinkedIn
pinterest_shares | false | Number of times Item has been shared on Pinterest
stumbleupon_shares | false | Number of times Item has been shared on StumbleUpon
total_shares | false | Number of times Item has been shared on Social Media

<aside class="notice">
You must replace `:CONTAINER` with the available container you are matching against.
</aside>



## Get Item in JSON

> Request example

```shell
curl "http://localhost:3000/v1/amazon-offers/B00DR0PDNE"
  -H "Authorization: Token token=YOUR-ACCESS-TOKEN"
```

> The above command returns JSON structured like this:

```json
{
  "response": {
    "status": 200
  },
  "url": "http://www.amazon.com/Google-Chromecast-Streaming-Media-Player/dp/B00DR0PDNE",
  "date": "2015-02-24",
  "id": "B00DR0PDNE",
  "tags": [
    "Google",
    "Chromecast",
    "HDMI",
    "Streaming",
    "Media",
    "Player",
    "Inc.",
    "H2G2-42",
    "86002596-01"
  ],
  "name": "Google Chromecast HDMI Streaming Media Player",
  "description": "Amazon.com: Google Chromecast HDMI Streaming Media Player: Electronics",
  "type": "Offer",
  "image": "http://ecx.images-amazon.com/images/I/811nvG%2BLgML._SL1500_.jpg",
  "sku": "B00DR0PDNE",
  "screenshot": "B00DR0PDNE/2015-02-24.jpg",
  "price": "30.07",
  "original_price": "35.00",
  "facebook_shares": 48466,
  "google_shares": 5776,
  "twitter_shares": 177,
  "reddit_shares": 149,
  "linkedin_shares": 364,
  "pinterest_shares": 106,
  "stumbleupon_shares": 23,
  "total_shares": 55061
}
```

Get most up to date Item information by Item id.

### HTTP Request

`GET http://localhost:3000/v1/:CONTAINER/:ID`

### Query Parameters

Parameter | Required | Description
--------- | ------- | -----------
access_token | true | Access token used to authenticate
:CONTAINER | true| The available container
:ID | true | Item ID
fetch | false | Automatically crawl new data (default: true)
social | false | Automatically fetch new social data (default: false)

<aside class="notice">
You must replace `:CONTAINER` with the available container and `:ID` with the Item ID.
</aside>




## Get Item in XML

> Request example

```shell
curl "http://localhost:3000/v1/amazon-offers/B00DR0PDNE.xml"
  -H "Authorization: Token token=YOUR-ACCESS-TOKEN"
```

> The above command returns XML structured like this:

```xml
<hash>
  <response>
    <status type="integer">200</status>
  </response>
  <url>
  http://www.amazon.com/Google-Chromecast-Streaming-Media-Player/dp/B00DR0PDNE
  </url>
  <date>2015-02-24</date>
  <id>B00DR0PDNE</id>
  <tags type="array">
    <tag>Google</tag>
    <tag>Chromecast</tag>
    <tag>HDMI</tag>
    <tag>Streaming</tag>
    <tag>Media</tag>
    <tag>Player</tag>
    <tag>Inc.</tag>
    <tag>H2G2-42</tag>
    <tag>86002596-01</tag>
  </tags>
  <name>Google Chromecast HDMI Streaming Media Player</name>
  <description>
  Amazon.com: Google Chromecast HDMI Streaming Media Player: Electronics
  </description>
  <type>Offer</type>
  <image>
  http://ecx.images-amazon.com/images/I/811nvG%2BLgML._SL1500_.jpg
  </image>
  <sku>B00DR0PDNE</sku>
  <screenshot>B00DR0PDNE/2015-02-24.jpg</screenshot>
  <price>30.07</price>
  <original-price>35.00</original-price>
  <facebook-shares type="integer">48466</facebook-shares>
  <google-shares type="integer">5776</google-shares>
  <twitter-shares type="integer">177</twitter-shares>
  <reddit-shares type="integer">149</reddit-shares>
  <linkedin-shares type="integer">364</linkedin-shares>
  <pinterest-shares type="integer">106</pinterest-shares>
  <stumbleupon-shares type="integer">23</stumbleupon-shares>
  <total-shares type="integer">55061</total-shares>
</hash>
```

Get most up to date Item information by Item id.

### HTTP Request

`GET http://localhost:3000/v1/:CONTAINER/:ID.xml`

### Query Parameters

Parameter | Required | Description
--------- | ------- | -----------
access_token | true | Access token used to authenticate
:CONTAINER | true| The available container
:ID | true | Item ID
fetch | false | Automatically crawl new data (default: true)
social | false | Automatically fetch new social data (default: false)

<aside class="notice">
You must replace `:CONTAINER` with the available container and `:ID` with the Item ID.
</aside>




## Get Item History in JSON

> Request example

```shell
curl "http://localhost:3000/v1/amazon-offers/B00DR0PDNE/history"
  -H "Authorization: Token token=YOUR-ACCESS-TOKEN"
```

> The above command returns JSON structured like this:

```json
{
  "response": {
    "status": 200
  },
  "id": "B00DR0PDNE",
  "name": "Google Chromecast HDMI Streaming Media Player",
  "sku": {
    "2015-02-09": "B00DR0PDNE"
  },
  "screenshot": {
    "2015-02-09": "B00DR0PDNE/2015-02-09.jpg",
    "2015-02-10": "B00DR0PDNE/2015-02-10.jpg",
    "2015-02-21": "B00DR0PDNE/2015-02-21.jpg",
    "2015-02-24": "B00DR0PDNE/2015-02-24.jpg"
  },
  "price": {
    "2015-02-09": "32.49",
    "2015-02-10": "31.78",
    "2015-02-21": "30.07"
  },
  "original_price": {
    "2015-02-09": "35.00"
  }
}
```

Get most up to date Item history by Item id.

### HTTP Request

`GET http://localhost:3000/v1/:CONTAINER/:ID/history`

### Query Parameters

Parameter | Required | Description
--------- | ------- | -----------
access_token | true | Access token used to authenticate
:CONTAINER | true| The available container
:ID | true | Item ID
fetch | false | Automatically crawl new data (default: true)
social | false | Automatically fetch new social data (default: false)

<aside class="notice">
You must replace `:CONTAINER` with the available container and `:ID` with the Item ID.
</aside>




## Get Item Screenshot Image

> Request example

```shell
curl "http://localhost:3000/v1/amazon-offers/B00DR0PDNE/2015-02-24.jpg"
  -H "Authorization: Token token=YOUR-ACCESS-TOKEN"
```

> The above command redirects to a URL like the one below:

```html
  <html>
    <body>
    You are being
    <a href="https://amazon-screenshots.s3.amazon.com/B00DR0PDNE/2015-02-24.jpg?AWSAccessKeyId=AUTO-GENERATED&Signature=AUTO-GENERATED&Expires=24-HOURS">redirected</a>.
    </body>
  </html>
```

Get Item redirect to screenshot image.

### HTTP Request

`GET http://localhost:3000/v1/:CONTAINER/:ID/:SCREENSHOT_DATE.jpg`

### Query Parameters

Parameter | Required | Description
--------- | ------- | -----------
access_token | true | Access token used to authenticate
:CONTAINER | true| The available container
:ID | true | Item ID
:SCREENSHOT_DATE | true | Date screenshot was captured

<aside class="notice">
You must replace `:CONTAINER` with the available container, `:ID` with the Item ID and `:SCREENSHOT_DATE` with date screenshot was taken.
</aside>




## Get Item Screenshot in JSON

> Request example

```shell
curl "http://localhost:3000/v1/amazon-offers/B00DR0PDNE/2015-02-24"
  -H "Authorization: Token token=YOUR-ACCESS-TOKEN"
```

> The above command returns JSON structured like this:

```json
{
  "response": {
    "status": 200
  },
  "id": "B00DR0PDNE",
  "redirect_url": "https://amazon-screenshots.s3.amazon.com/B00DR0PDNE/2015-02-24.jpg?AWSAccessKeyId=AUTO-GENERATED&Signature=AUTO-GENERATED&Expires=24-HOURS"
}
```

Get Item screenshot in JSON form.

### HTTP Request

`GET http://localhost:3000/v1/:CONTAINER/:ID/:SCREENSHOT_DATE`

### Query Parameters

Parameter | Required | Description
--------- | ------- | -----------
access_token | true | Access token used to authenticate
:CONTAINER | true| The available container
:ID | true | Item ID
:SCREENSHOT_DATE | true | Date screenshot was captured

<aside class="notice">
You must replace `:CONTAINER` with the available container, `:ID` with the Item ID and `:SCREENSHOT_DATE` with date screenshot was taken.
</aside>



## Get Item Screenshot in XML

> Request example

```shell
curl "http://localhost:3000/v1/amazon-offers/B00DR0PDNE/2015-02-24.xml"
  -H "Authorization: Token token=YOUR-ACCESS-TOKEN"
```

> The above command returns XML structured like this:

```xml
<hash>
  <response>
    <status type="integer">200</status>
  </response>
  <id>B00DR0PDNE</id>
  <redirect-url>
  https://amazon-screenshots.s3.amazon.com/B00DR0PDNE/2015-02-24.jpg?AWSAccessKeyId=AUTO-GENERATED&Signature=AUTO-GENERATED&Expires=24-HOURS
  </redirect-url>
</hash>
```

Get Item screenshot in XML form.

### HTTP Request

`GET http://localhost:3000/v1/:CONTAINER/:ID/:SCREENSHOT_DATE.xml`

### Query Parameters

Parameter | Required | Description
--------- | ------- | -----------
access_token | true | Access token used to authenticate
:CONTAINER | true| The available container
:ID | true | Item ID
:SCREENSHOT_DATE | true | Date screenshot was captured

<aside class="notice">
You must replace `:CONTAINER` with the available container, `:ID` with the Item ID and `:SCREENSHOT_DATE` with date screenshot was taken.
</aside>



## Search All Items in JSON

> Request example

```shell
curl "http://localhost:3000/v1/search/chromecast"
  -H "Authorization: Token token=YOUR-ACCESS-TOKEN"
```

> The above command returns JSON structured like this:

```json
{
  "response": {
    "status": 200
  },
  "results": [
    {
      "id": "B00DR0PDNE",
      "name": "Google Chromecast HDMI Streaming Media Player",
      "container": "amazon-offers"
    },
    {
      "id": "811571013579",
      "name": "Google Chromecast HDMI Streaming Media Player",
      "container": "walmart-offers"
    },
    {
      "name": "Google Chromecast HDMI Streaming Media Player",
      "id": "15460778",
      "container": "target-offers"
    },
    {
      "id": "945132",
      "name": "Google Chromecast HDMI Streaming Media Player with $10 Google Play Credit",
      "container": "costco-offers"
    }
  ]
}
```

Search all availble Items based on a query or key word.

### HTTP Request

`GET http://localhost:3000/v1/search/:QUERY`

### Query Parameters

Parameter | Required | Description
--------- | ------- | -----------
access_token | true | Access token used to authenticate
:QUERY | true | What you are searching for

<aside class="notice">
You must replace `:QUERY` with what you are searching for.
</aside>




## Search All Items in XML

> Request example

```shell
curl "http://localhost:3000/v1/search/chromecast.xml"
  -H "Authorization: Token token=YOUR-ACCESS-TOKEN"
```

> The above command returns XML structured like this:

```xml
<hash>
  <response>
    <status type="integer">200</status>
  </response>
  <results type="array">
    <result>
      <id>B00DR0PDNE</id>
      <name>Google Chromecast HDMI Streaming Media Player</name>
      <container>amazon-offers</container>
    </result>
    <result>
      <id>811571013579</id>
      <name>Google Chromecast HDMI Streaming Media Player</name>
      <container>walmart-offers</container>
    </result>
    <result>
      <name>Google Chromecast HDMI Streaming Media Player</name>
      <id>15460778</id>
      <container>target-offers</container>
    </result>
    <result>
      <id>945132</id>
      <name>Google Chromecast HDMI Streaming Media Player with $10 Google Play Credit</name>
      <container>costco-offers</container>
    </result>
  </results>
</hash>
```

Search all availble Items based on a query or key word

### HTTP Request

`GET http://localhost:3000/v1/search/:QUERY.xml`

### Query Parameters

Parameter | Required | Description
--------- | ------- | -----------
access_token | true | Access token used to authenticate
:QUERY | true | What you are searching for

<aside class="notice">
You must replace `:QUERY` with what you are searching for.
</aside>



## Match All Items in JSON

> Request example

```shell
curl "http://localhost:3000/v1/match?name=chromecast"
  -H "Authorization: Token token=YOUR-ACCESS-TOKEN"
```

> The above command returns JSON structured like this:

```json
{
  "response": {
    "status": 200
  },
  "results": [
    {
      "id": "B00DR0PDNE",
      "name": "Google Chromecast HDMI Streaming Media Player",
      "container": "amazon-offers"
    },
    {
      "id": "811571013579",
      "name": "Google Chromecast HDMI Streaming Media Player",
      "container": "walmart-offers"
    },
    {
      "name": "Google Chromecast HDMI Streaming Media Player",
      "id": "15460778",
      "container": "target-offers"
    },
    {
      "id": "945132",
      "name": "Google Chromecast HDMI Streaming Media Player with $10 Google Play Credit",
      "container": "costco-offers"
    }
  ]
}
```

Match all Items based on a specific set of known parameters and values.

### HTTP Request

`GET http://localhost:3000/v1/match`

### Query Parameters

Parameter | Required | Description
--------- | ------- | -----------
access_token | true | Access token used to authenticate
:CONTAINER | true| The available container you are searching in
:QUERY | true | What you are searching for
results | false | Number of Results you want back (default: 10)
fetch | false | Automatically crawl new data (default: true)
social | false | Automatically fetch new social data (default: false)
url | false | Unique URL for Item
date | false | When data was last gathered
id | false | Unique ID for Item
tags | false | Tags associated with Item
name | false | Unique name of Item
description | false | Given description for Item
type | false | Item Type
image | false | Unique Item image
facebook_shares | false | Number of times Item has been shared on Facebook
google_shares | false | Number of times Item has been shared on Google Plus
twitter_shares | false | Number of times Item has been shared on Twitter
reddit_shares | false | Number of times Item has been shared on Reddit
linkedin_shares | false | Number of times Item has been shared on LinkedIn
pinterest_shares | false | Number of times Item has been shared on Pinterest
stumbleupon_shares | false | Number of times Item has been shared on StumbleUpon
total_shares | false | Number of times Item has been shared on Social Media




## Match All Items in XML

> Request example

```shell
curl "http://localhost:3000/v1/match.xml?name=chromecast"
  -H "Authorization: Token token=YOUR-ACCESS-TOKEN"
```

> The above command returns XML structured like this:

```xml
<hash>
  <response>
    <status type="integer">200</status>
  </response>
  <results type="array">
    <result>
      <id>B00DR0PDNE</id>
      <name>Google Chromecast HDMI Streaming Media Player</name>
      <container>amazon-offers</container>
    </result>
    <result>
      <id>811571013579</id>
      <name>Google Chromecast HDMI Streaming Media Player</name>
      <container>walmart-offers</container>
    </result>
    <result>
      <name>Google Chromecast HDMI Streaming Media Player</name>
      <id>15460778</id>
      <container>target-offers</container>
    </result>
    <result>
      <id>945132</id>
      <name>Google Chromecast HDMI Streaming Media Player with $10 Google Play Credit</name>
      <container>costco-offers</container>
    </result>
  </results>
</hash>
```

Match all Items based on a specific set of known parameters and values.

### HTTP Request

`GET http://localhost:3000/v1/match.xml`

### Query Parameters

Parameter | Required | Description
--------- | ------- | -----------
access_token | true | Access token used to authenticate
:CONTAINER | true| The available container you are searching in
:QUERY | true | What you are searching for
results | false | Number of Results you want back (default: 10)
fetch | false | Automatically crawl new data (default: true)
social | false | Automatically fetch new social data (default: false)
url | false | Unique URL for Item
date | false | When data was last gathered
id | false | Unique ID for Item
tags | false | Tags associated with Item
name | false | Unique name of Item
description | false | Given description for Item
type | false | Item Type
image | false | Unique Item image
facebook_shares | false | Number of times Item has been shared on Facebook
google_shares | false | Number of times Item has been shared on Google Plus
twitter_shares | false | Number of times Item has been shared on Twitter
reddit_shares | false | Number of times Item has been shared on Reddit
linkedin_shares | false | Number of times Item has been shared on LinkedIn
pinterest_shares | false | Number of times Item has been shared on Pinterest
stumbleupon_shares | false | Number of times Item has been shared on StumbleUpon
total_shares | false | Number of times Item has been shared on Social Media
