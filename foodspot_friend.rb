#!/usr/bin/env ruby

# This script uses Selenium WebDriver and Safari to scrape the friends and
# followers lists of the currently logged-in Foodspotting user.
# Then it groups the contacts into 3 sets: mutual friends, only followers, and
# only following.

require 'selenium-webdriver'
require 'set'
require 'optparse'

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

options = {}

optp = OptionParser.new

optp.banner = "Usage: #{File.basename $PROGRAM_NAME} [options]"

optp.on('-h', '-?', '--help', 'Option help') {
  puts optp
  exit
}

optp.on('-m', '--mutual', 'Show mutual friends') {
  options[:mutual_friends] = true
}

optp.on('-r', '--only-friends', 'Show only-friends') {
  options[:only_friends] = true
}

optp.on('-o', '--only-followers', 'Show only-followers') {
  options[:only_followers] = true
}

optp.separator '  If none of -m/-r/-o are specified, display all 3 categories.'

optp.parse!

if !options[:mutual_friends] && !options[:only_friends] && !options[:only_followers]
  # If none of the 3 options are specified, show everything.
  options[:mutual_friends] = options[:only_friends] = options[:only_followers] = true
end

web = nil
begin
  web = Selenium::WebDriver.for :safari
  username = get_user_name web

  followers = Set.new(process_list(:followers, username, web))
  following = Set.new(process_list(:following, username, web))

  if options[:mutual_friends]
    puts 'Mutual followers:'
    show_list(following & followers)
  end

  if options[:only_followers]
    puts 'Only followers:'
    show_list(followers - following)
  end

  if options[:only_friends]
    puts 'Only following:'
    show_list(following - followers)
  end
ensure
  web.close if web
end

__END__
