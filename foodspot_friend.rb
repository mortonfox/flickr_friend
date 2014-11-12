#!/usr/bin/env ruby

# This script uses Selenium WebDriver, Nokogiri and Safari to scrape the
# friends and followers lists of the currently logged-in Foodspotting user.
# Then it groups the contacts into 3 sets: mutual friends, only followers, and
# only following.

require 'selenium-webdriver'
require 'nokogiri'
require 'set'

def get_user_name web
  puts 'Getting user name...'
  url = 'http://foodspotting.com/me'
  web.get url
  m = web.current_url.match(%r{foodspotting\.com/([^/]+)$})
  fail 'Unable to retrieve user name. Please log in to Foodspotting before running this script.' unless m
  m[1]
end

web = nil
begin
  web = Selenium::WebDriver.for :safari
  username = get_user_name web
  p username
ensure
  web.close if web
end

__END__
