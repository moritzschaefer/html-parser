#!/usr/bin/env ruby
# fetch baselink = http://ruby.railstutorial.org/chapters
# 
# #table_of_contents <li class="chapter"><a href="link"> click each of thos and then parse the site for <div class="highlight">. write the content of the divs into new html files
#
require 'nokogiri'
require 'open-uri'
require 'debugger'

$base_link = "http://ruby.railstutorial.org/chapters"

def do_links(links)
  i = 0
  links.each do |link|
    i += 1
    begin
      loclink = $base_link+"/"+link
      doc = Nokogiri::HTML(open(loclink))
    rescue
      print "Couldn't open link: " + loclink
      debugger
      next
    end
    regex = /\/?(.*)#/
    begin
      file_name = regex.match(link)[1]
    rescue
      debugger
    end

    File.open(file_name+i.to_s+".html", "w") do |f|
      f.write "<!DOCTYPE><html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"styles.css\"></head><body>"
      f.write doc.css(".highlight").map{|h| h.to_s}.join("\n")
      f.write "</body></html>"
    end
  end
end

def main
  doc = Nokogiri::HTML(open($base_link))
  toc = doc.css("#table_of_contents")
  links =toc.css("li.chapter a").map { |link| link.attr("href") }
  do_links links
end

if __FILE__ == $0
  main
end

