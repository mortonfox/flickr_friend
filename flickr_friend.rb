#!/usr/bin/env ruby
require 'selenium-webdriver'
require 'nokogiri'
require 'set'

def get_last_page doc
  doc.css('div.Pages a[href*="contacts/"]').map { |elem|
    elem['href'].match(%r(contacts(?:/rev)?/\?page=(\d+)))[1].to_i
  }.max
end

def get_names doc
  doc.css('td.contact-list-name').map { |elem|
    a_elem = elem.css('a').first
    id = a_elem['href'].match(%r(photos/(.*)/))[1]
    name = a_elem.children.first.to_s
    { id: id, name: name }
  }
end

def process_list what, username, web
  puts "Fetching #{what} page 1..."

  base_url = "https://www.flickr.com/people/#{username}/contacts/"
  base_url += 'rev/' if what == :follower
  web.get base_url

  doc = Nokogiri.HTML web.page_source
  last_page = get_last_page doc
  names = get_names doc

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

if ARGV.size < 1
  warn "Usage: $0 username"
  exit 1
end

username = ARGV[0]
web = Selenium::WebDriver.for :safari

following = Set.new(process_list :following, username, web)
follower = Set.new(process_list :follower, username, web)

puts 'Mutual followers:'
show_list(following & follower)

puts 'Only followers:'
show_list(follower - following)

puts 'Only following:'
show_list(following - follower)

__END__
