# flickr\_friend

This script uses [Selenium WebDriver](http://www.seleniumhq.org/),
[Nokogiri](http://www.nokogiri.org/) and Safari to scrape the
[Flickr](https://www.flickr.com) friends and followers lists of the currently
logged-in Flickr user. Then it groups the contacts into 3 sets: mutual friends,
only followers, and only following.

Web scraping is unfortunately necessary because while the Flickr API provides
an endpoint for retrieving the user's following list, it still doesn't have a
way to retrieve the user's followers.

Selenium WebDriver works with some of the most common web browsers. The reason
for choosing Safari here is because Selenium is able to launch a Safari
instance with the user's cookies, avoiding the need to log in to Flickr again.
Chrome and Firefox, on the other hand, launch as blank/incognito browsers under
Selenium.

## Installation

First, you need to install SafariDriver:

* Download SafariDriver from [Selenium Downloads](http://www.seleniumhq.org/download/)
* Open SafariDriver.safariextz in Finder. This will install the extension.

Then you need to install the required Ruby gems:

    gem install selenium-webdriver
    gem install nokogiri

## Usage

First, make sure that you're already logged in to Flickr on the Safari browser.

Then run the script:

    ruby flickr_friend.rb

## foodspot\_friend

This script is similar to flickr\_friend, except that it is for the
[Foodspotting](http://www.foodspotting.com) website instead.

To use it, first make sure that you're already logged in to Foodspotting on the
Safari browser.

Then run the script:

    ruby foodspot_friend.rb

## flickr\_friend\_oga and foodspot\_friend\_oga

flickr\_friend\_oga.rb and foodspot\_friend\_oga.rb are the same as
flickr\_friend.rb and foodspot\_friend.rb, except that these use
[Oga](https://github.com/YorickPeterse/oga) instead of Nokogiri.

Thus:

    gem install oga
    ruby flickr_friend_oga.rb
    ruby foodspot_friend_oga.rb

