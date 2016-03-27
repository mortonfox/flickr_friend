#!/usr/bin/env ruby

# This script uses Selenium WebDriver and Safari to scrape the Flickr friends
# and followers lists of the currently logged-in Flickr user.
# Then it groups the contacts into 3 sets: mutual friends, only followers, and
# only following.

require 'selenium-webdriver'
require 'set'

# Find the highest-numbered page by parsing the pages links.
def get_last_page web
  web.find_elements(:css, 'div.Pages a[href*="contacts/"]').map { |elem|
    elem.attribute('href').match(%r{contacts(?:/rev)?/\?page=(\d+)})[1].to_i
  }.max
end

# Parse user IDs and names from the contact list.
def get_names web
  web.find_elements(:css, 'td.contact-list-name').map { |elem|
    a_elem = elem.find_element(:tag_name, 'a')
    id = a_elem.attribute('href').match(%r{photos/(.*)/})[1]
    name = a_elem.text.strip
    { id: id, name: name }
  }
end

# Get the user name.
def get_user_name web
  m = web.current_url.match(%r{people/(.+)/contacts})
  raise 'Unable to retrieve user name. Please log in to Flickr before running this script.' unless m
  m[1]
end

# Process the contact list, returning a list of users from all the pages in
# the list.
def process_list what, web
  puts "Fetching #{what} page 1..."

  base_url = 'https://www.flickr.com/people/me/contacts/'
  base_url += 'rev/' if what == :follower
  web.get base_url
  username = get_user_name web

  last_page = get_last_page web
  names = get_names web

  # Only the first page can use people/me. Subsequent pages need the actual
  # user name.
  base_url = "https://www.flickr.com/people/#{username}/contacts/"
  base_url += 'rev/' if what == :follower

  (2..last_page).each { |page|
    puts "Fetching #{what} page #{page}..."
    web.get "#{base_url}?page=#{page}"

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

  following = Set.new(process_list(:following, web))
  follower = Set.new(process_list(:follower, web))

  puts 'Mutual followers:'
  show_list(following & follower)

  puts 'Only followers:'
  show_list(follower - following)

  puts 'Only following:'
  show_list(following - follower)
ensure
  web.close if web
end

__END__
