require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'ruby-debug'
namespace :create do
  desc "some dude"
  task :party => :environment do
    url = "http://eci.nic.in/archive/March2004/pollupd/ac/AE_NatHighlights.htm"
    doc = open(url) { |f| Hpricot(f) }
    (doc/"/html/body/center/table/tbody/tr[@bgcolor]").search("td[@width=40%").search("font[@size=2]").each do |p|
      matcher = p.inner_html.strip.match(/\(?\w+\)$/)
      if  matcher
        party = $&.gsub("(","")
        party.gsub!(")","")
        Party.create(:name => matcher.pre_match.strip,:code => party)
      end
    end

  end
end
