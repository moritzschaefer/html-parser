#!/usr/bin/env ruby
# fetch baselink = http://ruby.railstutorial.org/chapters
# 
# #table_of_contents <li class="chapter"><a href="link"> click each of thos and then parse the site for <div class="highlight">. write the content of the divs into new html files
#
require 'nokogiri'
require 'open-uri'
require 'debugger'
base_link = "http://ruby.railstutorial.org/chapters"
doc = Nokogiri::HTML(open(base_link))
toc = doc.css("#table_of_contents")
links =toc.css("li.chapter a").map { |link| link.attr("href") }

links.each do |link|
  doc = Nokogiri::HTML(open(base_link+link))
  file_name = /\/(.*)#/.match(link)[1]
  
  File.open(file_name, "w") do |f|
    f.write doc.css(".highlight").map{|h| h.to_s}.join("\n")
  end
end
