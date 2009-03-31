require 'rubygems'
require 'open-uri'
require 'hpricot'
namespace :seat do
  desc "some dude"
  task :avalid => :environment do
    AssemblyNomination.find(:all).each do |val|
      puts val.id unless val.valid?
    end
  end

  task :pvalid => :environment do
    ParliamentNomination.find(:all).each do |val|
      puts val.id unless val.valid?
    end
  end
  task :retry => :environment do
    Seat.find_all_by_lat(nil).each do |seat|
      clt = Geokit::Geocoders::GoogleGeocoder.geocode(seat.name)
      clt = Geokit::Geocoders::GoogleGeocoder.geocode(seat.locality) if clt.lat.nil? && !seat.locality.nil?
      unless clt.lat.nil?
        #seat.update_attributes(:name => seat,:lat => clt.lat,:lng=>clt.lng)
        puts "found"
      end
        puts seat.name
        puts seat.id
    end
  end
end
