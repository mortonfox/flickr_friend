# flickr_friend

This script uses [Selenium WebDriver](http://www.seleniumhq.org/), [Nokogiri](http://www.nokogiri.org/) and Safari to scrape the Flickr friends and followers lists of the currently logged-in Flickr user. Then it groups the contacts into 3 sets: mutual friends, only followers, and only following.

Web scraping is unfortunately necessary because while the Flickr API provides an endpoint for retrieving the user's following list, it still doesn't have a way to retrieve the user's followers.

Selenium WebDriver works with some of the most common web browsers. The reason for preferring Safari here is because Selenium is able to launch a Safari instance with the user's cookies, avoiding the need to log in to Flickr again. Chrome and Firefox, on the other hand, launch as blank/incognito browsers under Selenium.

## Installation

First, you need to get the Selenium Standalone Server up and running.
 * Download Selenium Server from [Selenium Downloads](http://www.seleniumhq.org/download/)
 * Run Selenium Server like so: ```java -jar selenium-server-standalone-2.44.0.jar```

The [SafariDriver](https://code.google.com/p/selenium/wiki/SafariDriver) browser extension is bundled with Selenium Server. However, it doesn't seem to get installed automatically under OS X Yosemite (and possibly Mavericks too). Fortunately, it is easy to add the browser extension by hand:

    mkdir selenium
    cd selenium
    tar xvf ../selenium-server-standalone-2.44.0.jar
    open org/openqa/selenium/safari/SafariDriver.safariextz

Then you need to install the required Ruby gems:

    gem install selenium-webdriver
    gem install nokogiri

## Usage

First, make sure that you're already logged in to Flickr on Safari.

Then run the script:

    ruby flickr_friend.rb
