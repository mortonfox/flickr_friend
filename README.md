# flickr\_friend

This script uses [Selenium WebDriver](http://www.seleniumhq.org/) and Firefox
to scrape the [Flickr](https://www.flickr.com) friends and followers lists of
the currently logged-in Flickr user. Then it groups the contacts into 3 sets:
mutual friends, only followers, and only following.

Web scraping is unfortunately necessary because while the Flickr API provides
an endpoint for retrieving the user's following list, it still doesn't have a
way to retrieve the user's followers.

## Installation

First, you need to install GeckoDriver:

* Download [the latest GeckoDriver release](https://github.com/mozilla/geckodriver/releases)
* Move the geckodriver binary to one of the folders in your PATH.

Then install the required Ruby gem:

    gem install selenium-webdriver

## Usage

Run the script:

    ruby flickr_friend.rb

You can control what this script outputs using the -m, -r, and -o options:

    $ ruby flickr_friend.rb -h
    This script uses Selenium WebDriver and Firefox to scrape the Flickr friends
    and followers lists of a Flickr user.
    Then it groups the contacts into 3 sets: mutual friends, only followers, and
    only following.

    Usage: flickr_friend.rb [options]
        -h, -?, --help                   Option help
        -m, --mutual                     Show mutual friends
        -r, --only-friends               Show only-friends
        -o, --only-followers             Show only-followers
    If none of -m/-r/-o are specified, display all 3 categories.
    $

# foodspot\_friend

This script is similar to flickr\_friend, except that it is for the
[Foodspotting](http://www.foodspotting.com) website instead.

## Installation

Follow the same steps as in flickr\_friend above.

## Usage

Run the script:

    ruby foodspot_friend.rb

You can control what this script outputs using the -m, -r, and -o options:

    $ ruby foodspot_friend.rb -h
    This script uses Selenium WebDriver and Firefox to scrape the friends and
    followers lists of a Foodspotting user.
    Then it groups the contacts into 3 sets: mutual friends, only followers, and
    only following.

    Usage: foodspot_friend.rb [options]
        -h, -?, --help                   Option help
        -m, --mutual                     Show mutual friends
        -r, --only-friends               Show only-friends
        -o, --only-followers             Show only-followers
    If none of -m/-r/-o are specified, display all 3 categories.
    $

