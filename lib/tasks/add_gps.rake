require 'rubygems'
require 'open-uri'
require 'hpricot'
namespace :gps do
  desc "add new locations"
  task :add, :c_id, :lat,:lng, :needs => [:environment] do |t, args|
    c = Constituency.find(args.c_id)
    if c
      if args.lat && args.lng
        c.update_attributes(:lat => args.lat , :lng => args.lng)
        puts Constituency.find_all_by_lat(0).collect{ |a| "#{a.id} #{a.name}" }
      end
    end
  end
end
