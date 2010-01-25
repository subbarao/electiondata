require 'rubygems'
require 'open-uri'
require 'hpricot'
namespace :create do
  desc "some dude"
  task :constiuency => :environment do
    url = 'http://eci.nic.in/archive/March2004/pollupd/ac/states/S01/a_index_right.htm'
    doc = open(url) { |f| Hpricot(f) }
    (doc/"/html/body/div/table a font").each do |p|
        matcher = p.inner_html.match(/\d+/)
        city = matcher.pre_match.gsub(/-/,"")
        reserved="OPEN"
        identity = matcher[0]

        reserve_match=city.strip.match(/\(?\w+\)$/)
        if reserve_match
          city = reserve_match.pre_match.strip
          reserved = reserve_match[0].gsub(/[()-]/,"")
        end
        puts "city name #{city}"
        puts "category #{reserved}"
        puts "identity #{identity}"
        Constituency.create(:name => city,:category=>reserved,:ec_id=>identity)
    end
  end
end
