#!/usr/bin/env ruby

# This script uses Selenium WebDriver, Nokogiri and Safari to scrape the
# Flickr friends and followers lists of the currently logged-in Flickr user.
# Then it generates 3 sets: mutual friends, only followers, and only
# following.
#
# The reason we need to scrape the Flickr website is while the Flickr API has
# an endpoint for retrieving the user's following list, it offers no way to
# retrieve the followers.
#
# The script uses Safari because that is the only browser that runs under
# Selenium with the user's cookies. Chrome and Firefox launch as
# blank/incognito browsers under Selenium.

require 'selenium-webdriver'
require 'nokogiri'
require 'set'

# Find the highest-numbered page by parsing the pages links.
def get_last_page doc
  doc.css('div.Pages a[href*="contacts/"]').map { |elem|
    elem['href'].match(%r(contacts(?:/rev)?/\?page=(\d+)))[1].to_i
  }.max
end

# Parse user IDs and names from the contact list.
def get_names doc
  doc.css('td.contact-list-name').map { |elem|
    a_elem = elem.css('a').first
    id = a_elem['href'].match(%r(photos/(.*)/))[1]
    name = a_elem.children.first.to_s
    { id: id, name: name }
  }
end

# Process the contact list, returning a list of users from all the pages in
# the list.
def process_list what, web
  puts "Fetching #{what} page 1..."

  base_url = "https://www.flickr.com/people/me/contacts/"
  base_url += 'rev/' if what == :follower
  web.get base_url

  doc = Nokogiri.HTML web.page_source
  last_page = get_last_page doc
  names = get_names doc
  username = web.current_url.match(%r(people/(.+)/contacts))[1]

  # Only the first page can use people/me. Subsequent pages need the actual
  # user name.
  base_url = "https://www.flickr.com/people/#{username}/contacts/"
  base_url += 'rev/' if what == :follower

  (2..last_page).each { |page|
    puts "Fetching #{what} page #{page}..."
    url = base_url + "?page=#{page}"
    web.get url

    doc = Nokogiri.HTML web.page_source
    names += get_names doc
  }

  names
end

def show_list flist
  flist.each_with_index { |name, i|
    puts "#{i+1}: #{name[:id]} - #{name[:name]}"
  }
end

web = nil
begin
  web = Selenium::WebDriver.for :safari

  following = Set.new(process_list :following, web)
  follower = Set.new(process_list :follower, web)

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
