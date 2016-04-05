# flickr\_friend

This script uses [Selenium WebDriver](http://www.seleniumhq.org/) and Safari to
scrape the [Flickr](https://www.flickr.com) friends and followers lists of the
currently logged-in Flickr user. Then it groups the contacts into 3 sets:
mutual friends, only followers, and only following.

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

Then you need to install the required Ruby gem:

    gem install selenium-webdriver

## Usage

First, make sure that you're already logged in to Flickr on the Safari browser.

Then run the script:

    ruby flickr_friend.rb

You can control what this script outputs using the -m, -r, and -o options:

    bash-4.3$ ruby flickr_friend.rb -h
    Usage: flickr_friend.rb [options]
        -h, -?, --help                   Option help
        -m, --mutual                     Show mutual friends
        -r, --only-friends               Show only-friends
        -o, --only-followers             Show only-followers
    If none of -m/-r/-o are specified, display all 3 categories.
    bash-4.3$

## foodspot\_friend

This script is similar to flickr\_friend, except that it is for the
[Foodspotting](http://www.foodspotting.com) website instead.

To use it, first make sure that you're already logged in to Foodspotting on the
Safari browser.

Then run the script:

    ruby foodspot_friend.rb

