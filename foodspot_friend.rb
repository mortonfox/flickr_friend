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

# Find the highest-numbered page by parsing the pages links.
def get_last_page doc
  doc.css('div.pagination a[href*="?page="]').map { |elem|
    elem['href'].match(%r{\?page=(\d+)})[1].to_i
  }.max
end

# Parse user IDs and names from the contact list.
def get_names doc
  doc.css('div.title a').map { |elem|
    id = elem['href'].sub(%r{^/}, '')
    name = elem.children.first.to_s
    { id: id, name: name }
  }
end

# Process the contact list, returning a list of users from all the pages in
# the list.
def process_list what, username, web
  puts "Fetching #{what} page 1..."

  url = "http://www.foodspotting.com/#{username}/#{what}"
  web.get url

  doc = Nokogiri.HTML web.page_source
  last_page = get_last_page doc
  puts "Last page is #{last_page}"
  names = get_names doc
  p names
end

web = nil
begin
  web = Selenium::WebDriver.for :safari
  username = get_user_name web
  p username

  process_list :followers, username, web
  process_list :following, username, web
ensure
  web.close if web
end

__END__
