#!/usr/bin/env ruby

# This script uses Selenium WebDriver and Safari to scrape the friends and
# followers lists of the currently logged-in Foodspotting user.
# Then it groups the contacts into 3 sets: mutual friends, only followers, and
# only following.

require 'selenium-webdriver'
require 'set'

# Get the user name.
def get_user_name web
  puts 'Getting user name...'
  url = 'http://foodspotting.com/me'
  web.get url
  m = web.current_url.match(%r{foodspotting\.com/([^/]+)$})
  raise 'Unable to retrieve user name. Please log in to Foodspotting before running this script.' unless m
  m[1]
end

# Find the highest-numbered page by parsing the pages links.
def get_last_page web
  web.find_elements(:css, 'div.pagination a[href*="?page="]').map { |elem|
    elem.attribute('href').match(/\?page=(\d+)/)[1].to_i
  }.max
end

# Parse user IDs and names from the contact list.
def get_names web
  web.find_elements(:css, 'div.title a').map { |elem|
    id = elem.attribute('href').sub(%r{^/}, '')
    name = elem.text.strip
    { id: id, name: name }
  }
end

# Process the contact list, returning a list of users from all the pages in
# the list.
def process_list what, username, web
  puts "Fetching #{what} page 1..."

  url = "http://www.foodspotting.com/#{username}/#{what}"
  web.get url

  last_page = get_last_page web
  names = get_names web

  (2..last_page).each { |page|
    puts "Fetching #{what} page #{page}..."
    web.get "#{url}?page=#{page}"

    names += get_names web
  }

  names
end

def show_list flist
  flist.each_with_index { |name, i|
    puts "#{i + 1}: #{name[:id]} - #{name[:name]}"
  }
end

web = nil
begin
  web = Selenium::WebDriver.for :safari
  username = get_user_name web

  followers = Set.new(process_list(:followers, username, web))
  following = Set.new(process_list(:following, username, web))

  puts 'Mutual followers:'
  show_list(following & followers)

  puts 'Only followers:'
  show_list(followers - following)

  puts 'Only following:'
  show_list(following - followers)
ensure
  web.close if web
end

__END__
