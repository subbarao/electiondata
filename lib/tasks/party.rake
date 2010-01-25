require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'geokit'
namespace :party do
  desc "inc some dude"
  task :prp => :environment do
    url = 'http://www.apelections2009.in/2009/03/23/prp-candidates-for-loksabha-elections-list/'
    doc = open(url) { |f| Hpricot(f) }
    #str=html/body/div[2]/div/div[5]/div/div/div/div/div[2]/div/p[2]
    debugger
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
  def find_in(city,candidate,dt)
    val = Constituency.find(:first,:conditions=>["name like ?","%#{city}%"])
  end
  def parse_city(html)
    elements = html.split(/[:,]/)
    dt = elements.shift
    count = (elements.size)/2
    total = 0
    hash = []
    count.times do |i|
      city = elements.shift.strip
      candidate = elements.shift.strip
      reserve_match=city.strip.match(/\(?\w+\)$/)
      if reserve_match
        city = reserve_match.pre_match.strip
        reserved = reserve_match[0].gsub(/[()-]/,"")
      end
      hash << city.to_s
      hash << candidate.to_s
    end
    hash
  end
  desc "inc"

  task :noinc => :environment do
    url = 'http://www.apelections2009.in/2009/03/23/congress-mla-candidates-list-for-ap-2009-elections/'
    doc = open(url) { |f| Hpricot(f) }
    #str=/html/body/div[2]/div/div[5]/div/div/div/div/div[2]/div/p[3]
    candidates = (doc/"/html/body/div[2]/div/div[5]/div/div/div/div/div[2]/div/p")
    hash = []
    22.times do |i|
      hash << parse_city(candidates[i+4].inner_text)
    end
    hash.flatten!

    File.open( 'somefile.yaml', 'w' ) do |out|
      YAML.dump( hash, out )
    end
    #url = 'http://www.apelections2009.in/2009/03/23/congress-mla-candidates-from-ranga-reddy-district-list/'
    #doc = open(url) { |f| Hpricot(f) }
    #candidates = (doc/"/html/body/div[2]/div/div[5]/div/div/div/div/div[2]/div/p[2]")
    #puts "Unfound cities #{counter}"
    #puts missed.sort
    #puts total_cities
  end
  def find_city(city)
    city_obj = AssemblySeat.find(:first,:conditions=>["name like ?","%#{city.upcase}%"])
    reserve_match=city.strip.match(/\(?\w+\)$/)
    if reserve_match
      city = reserve_match.pre_match.strip
      city_obj = AssemblySeat.find(:first,:conditions=>["name like ?","%#{city.upcase}%"]) if city_obj.nil?
      reserved = reserve_match[0].gsub(/[()-]/,"")
    end
    city_obj
  end
  namespace :prp do
    desc "cpi desam party nominees list"
    task :assem => :environment do
      data = File.open( 'second.yaml' ).read.split("\n")
      hash = []
      data.each do |inner|
        el=inner.split(",")
        el.shift
        el.each do |node|
          node = node.split(":")
          city = node[0].match(/\d+\s*./).post_match.strip.to_s
          cand = node[1].strip
          puts city if find_city(city)
          hash << city
          hash << cand
        end
      end
      File.open( 'party/assembly/prp_list2.yaml', 'w' ) do |out|
        YAML.dump( hash, out )
      end
    end
    task :find => :environment do
      data = File.open( 'party/assembly/prp_list.yaml' ){ |yf| YAML::load( yf ) }
      count = data.size/2
      total = 0
      Nomination.transaction do
        count.times do |i|
          city = find_city(data[2*i])
          total=total+1
          puts data[2*i] unless city
          #AssemblyNomination.create :name => candidate,:seat_id => city_obj.id,:party_id => 1
        end
      end
      puts total
    end

    task :pa_find => :environment do
      data = File.open( 'party/parliament/prp_list.yaml' ){ |yf| YAML::load( yf ) }
      count = data.size/2
      party_id = 71
      total = 0
      Nomination.transaction do
        count.times do |i|
          city = data[2*i].strip
          total=total+1
          puts data[2*i] unless city
          city = ParliamentSeat.find(:first,:conditions=>["name like ?",city])
          puts city if city.nil?
          cand=data[2*i+1]
          if !cand.nil? && cand.empty?
            count.times do |i|
              ParliamentNomination.create :name => cand,:seat_id => city.id,:party_id => party_id
            end
          end
          #AssemblyNomination.create :name => candidate,:seat_id => city_obj.id,:party_id => 1
        end
      end
      puts total
    end



    task :assembly => :environment do
      data = File.open( 'party/assembly/prp_list.yaml' ){ |yf| YAML::load( yf ) }
      count = data.size/2
      party_id = 71
      total = 0
      Nomination.transaction do
        count.times do |i|
          AssemblyNomination.create :name => data[2*i+1],:seat_id => find_city(data[2*i]).id,:party_id => party_id
        end
      end
    end



  end
  namespace :cpi do
    desc "cpi desam party nominees list"
    task :assem => :environment do
      data = File.open( 'mahakotami.yaml' ).read.split("\n")[7]
      hash = []
      data.split(";").each do |node|
        node = node.split(":")
        city = node[0].strip.upcase
        cand = node[1].strip
        puts city if AssemblySeat.find(:first,:conditions=>["name like ?","%#{city}%"]).nil?
        hash << city
        hash << cand
      end
      File.open( 'party/assembly/cpi_list.yaml', 'w' ) do |out|
        YAML.dump( hash, out )
      end
    end
    task :find => :environment do
      data = File.open( 'party/assembly/cpi_list.yaml' ){ |yf| YAML::load( yf ) }
      count = data.size/2
      total = 0
      Nomination.transaction do
        count.times do |i|
          city = find_city(data[2*i])
          total=total+1
          puts data[2*i] unless city
          #AssemblyNomination.create :name => candidate,:seat_id => city_obj.id,:party_id => 1
        end
      end
      puts total
    end

    task :assembly => :environment do
      data = File.open( 'party/assembly/cpi_list.yaml' ){ |yf| YAML::load( yf ) }
      count = data.size/2
      party_id =4
      total = 0
      Nomination.transaction do
        count.times do |i|
          AssemblyNomination.create :name => data[2*i+1],:seat_id => find_city(data[2*i]).id,:party_id => party_id
        end
      end
    end
  end
  namespace :trs do
    desc "trs desam party nominees list"
    task :assem => :environment do
      data = File.open( 'mahakotami.yaml' ).read.split("\n")[3]
      hash = []
      data.split(";").each do |node|
        node = node.split(":")
        city = node[0].strip.upcase
        cand = node[1].strip
        puts city if AssemblySeat.find(:first,:conditions=>["name like ?","%#{city}%"]).nil?
        hash << city
        hash << cand
      end
      File.open( 'party/assembly/trs_list.yaml', 'w' ) do |out|
        YAML.dump( hash, out )
      end
    end
    task :assembly => :environment do
      data = File.open( 'party/assembly/trs_list.yaml' ){ |yf| YAML::load( yf ) }
      count = data.size/2
      party_id = 20
      total = 0
      Nomination.transaction do
        count.times do |i|
          AssemblyNomination.create :name => data[2*i+1],:seat_id => find_city(data[2*i]).id,:party_id => party_id
        end
      end
    end

    task :find => :environment do
      data = File.open( 'party/assembly/trs_list.yaml' ){ |yf| YAML::load( yf ) }
      count = data.size/2
      total = 0
      Nomination.transaction do
        count.times do |i|
          city = find_city(data[2*i])
          total=total+1
          puts data[2*i] unless city
          #AssemblyNomination.create :name => candidate,:seat_id => city_obj.id,:party_id => 1
        end
      end
      puts total
    end
  end
  namespace :cpm do
    desc "cpm desam party nominees list"
    task :assem => :environment do
      data = File.open( 'mahakotami.yaml' ).read.split("\n")[5]
      hash = []
      data.split(";").each do |node|
        node = node.split(":")
        city = node[0].strip.upcase
        cand = node[1].strip
        puts city if AssemblySeat.find(:first,:conditions=>["name like ?","%#{city}%"]).nil?
        hash << city
        hash << cand
      end
      File.open( 'party/assembly/cpm_list.yaml', 'w' ) do |out|
        YAML.dump( hash, out )
      end
    end
    task :find => :environment do
      data = File.open( 'party/assembly/cpm_list.yaml' ){ |yf| YAML::load( yf ) }
      count = data.size/2
      total = 0
      Nomination.transaction do
        count.times do |i|
          city = find_city(data[2*i])
          total=total+1
          puts data[2*i] unless city
          #AssemblyNomination.create :name => candidate,:seat_id => city_obj.id,:party_id => 1
        end
      end
      puts total
    end
    task :assembly => :environment do
      data = File.open( 'party/assembly/cpm_list.yaml' ){ |yf| YAML::load( yf ) }
      count = data.size/2
      party_id = 3
      total = 0
      Nomination.transaction do
        count.times do |i|
          AssemblyNomination.create :name => data[2*i+1],:seat_id => find_city(data[2*i]).id,:party_id => party_id
        end
      end
    end

  end

  namespace :tdp do

    task :pa_find => :environment do
      data = File.open( 'party/parliament/tdp_list.yaml' ){ |yf| YAML::load( yf ) }
      count = data.size/2
      total = 0
      party_id = 8
      Nomination.transaction do
        count.times do |i|
          city = data[2*i].strip
          city = ParliamentSeat.find(:first,:conditions=>["name like ?",city])
          puts city if city.nil?
          cand=data[2*i+1].strip
          count.times do |i|
            ParliamentNomination.create :name => cand,:seat_id => city.id,:party_id => party_id
          end
          #AssemblyNomination.create :name => candidate,:seat_id => city_obj.id,:party_id => 1
        end
      end
      puts total
    end
    desc "telugu desam party nominees list"
    task :assem => :environment do
      data = File.open( 'mahakotami.yaml' ).read.split("\n")[1]
      hash = []
      data.split(";").each do |node|
        node = node.split(":")
        city = node[0].strip.upcase
        cand = node[1].strip
        puts city if AssemblySeat.find(:first,:conditions=>["name like ?","%#{city}%"]).nil?
        hash << city
        hash << cand
      end
      File.open( 'party/assembly/tdp_list.yaml', 'w' ) do |out|
        YAML.dump( hash, out )
      end
    end

    task :find => :environment do
      data = File.open( 'tdp_list.yaml' ) { |yf| YAML::load( yf ) }
      count = data.size/2
      total = 0
      Nomination.transaction do
        count.times do |i|
          city = data[2*i]
          candidate = data[2*i+1].strip
          city_obj = AssemblySeat.find_by_name(city.upcase)
          reserve_match=city.strip.match(/\(?\w+\)$/)
          if reserve_match
            city = reserve_match.pre_match.strip
            city_obj = AssemblySeat.find_by_name(city.upcase) if city_obj.nil?
            reserved = reserve_match[0].gsub(/[()-]/,"")
          end
          total=total+1
          puts city unless city_obj

          #AssemblyNomination.create :name => candidate,:seat_id => city_obj.id,:party_id => 1
        end
      end
      puts total
    end
    task :assembly => :environment do
      data = File.open( 'party/assembly/tdp_list.yaml' ){ |yf| YAML::load( yf ) }
      count = data.size/2
      party_id = 8
      total = 0
      Nomination.transaction do
        count.times do |i|
          AssemblyNomination.create :name => data[2*i+1],:seat_id => find_city(data[2*i]).id,:party_id => party_id
        end
      end
    end
  end

  namespace :cong do
    desc "congress party nominees list"
    task :parliament => :environment do
      url = 'http://blog.loksabhaelections2009.net/andhra-pradesh-congress-mp-candidates-list-for-2009-parliament-elections/comment-page-1/'
      doc = open(url) { |f| Hpricot(f) }
      str='/html/body/div/div[3]/div/div[2]/div/div/div[2]/div/table/tbody/tr'
      list = (doc/str)
      list.shift
      Nomination.transaction do
        list.each do |p|
          inner_list = p.search("/td strong")
          inner_list.shift
          seat = inner_list.shift.inner_text.strip
          cand = inner_list.shift.inner_text.strip
          seat = ParliamentSeat.find_by_name(seat)
          ParliamentNomination.create :name => cand,:seat_id => seat.id,:party_id => 1
          puts "city name #{seat}"
          puts "identity #{cand}"
        end
      end
    end
    task :assembly => :environment do
      data = File.open( 'candidates.yaml' ) { |yf| YAML::load( yf ) }
      count = data.size/2
      total = 0
      Nomination.transaction do
        count.times do |i|
          city = data[2*i]
          candidate = data[2*i+1].strip
          city_obj = AssemblySeat.find_by_name(city.upcase)
          reserve_match=city.strip.match(/\(?\w+\)$/)
          if reserve_match
            city = reserve_match.pre_match.strip
            city_obj = AssemblySeat.find_by_name(city.upcase) if city_obj.nil?
            reserved = reserve_match[0].gsub(/[()-]/,"")
          end
          total=total+1
          AssemblyNomination.create :name => candidate,:seat_id => city_obj.id,:party_id => 1
        end
      end
      puts total
    end
  end

  task :new_par => :environment do
    url = 'http://blog.loksabhaelections2009.net/andhra-pradesh-congress-mp-candidates-list-for-2009-parliament-elections/comment-page-1/'
    doc = open(url) { |f| Hpricot(f) }
    str='/html/body/div/div[3]/div/div[2]/div/div/div[2]/div/table/tbody/tr'
    list = (doc/str)
    list.shift
    AssemblySeat.transaction do
      list.each do |p|
        inner_list = p.search("/td strong")
        inner_list.shift
        seat = inner_list.shift.inner_text
        cand = inner_list.shift.inner_text
        clt = Geokit::Geocoders::GoogleGeocoder.geocode(seat.split(" ")[0])
        ParliamentSeat.create(:name => seat,:lat => clt.lat,:lng=>clt.lng)
        puts "city name #{seat}"
        puts "identity #{cand}"
      end
    end
  end

  task :assembly => :environment do
    dt_url = 'http://andhra.yestopolitics.com/districts'
    dt_doc = open(dt_url) { |f| Hpricot(f) }
    class_names ='.tableSecondRow,.tableFirstRow'
    total_dt=0
    total_const =0
    hash = {}
    District.transaction do
      (dt_doc/class_names).each do |dt_list|
        current_dt = dt_list.search('b a').inner_text
        dlt = Geokit::Geocoders::GoogleGeocoder.geocode(current_dt).to_lat_lng
        dt = District.create(:name => current_dt,:lat => dlt.lat,:lng=>dlt.lng)
        total_dt=total_dt+1
        puts "District name #{current_dt}"
        url = "http://andhra.yestopolitics.com/elections/assembly/clist/dist/#{current_dt}/"
        doc = open(url) { |f| Hpricot(f) }
        city_list=[]
        (doc/class_names).each do |inner_list|

          city_info = inner_list.search('td')
          city_info.shift
          seat = city_info.shift.inner_text.strip
          active = city_info.shift.inner_text.strip
          if active.downcase =="active" || active.downcase =="added"
            total_const =total_const+1
            city_list << seat
            clt = Geokit::Geocoders::GoogleGeocoder.geocode(seat.split(" ")[0])
            AssemblySeat.create(:name => seat,:district_id => dt.id,:lat => clt.lat,:lng=>clt.lng)
          end
        end
        hash.merge!(current_dt=>city_list)
      end
    end
    puts "districts #{total_dt}"
    puts "const #{total_const}"

    File.open( 'cities.yaml', 'w' ) do |out|
      YAML.dump( hash, out )
    end
  end



end
