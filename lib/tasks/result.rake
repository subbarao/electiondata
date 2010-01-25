require 'rubygems'
require 'open-uri'
require 'hpricot'
namespace :create do
  def find_contents(node,index)
    node.search("td")[index].search("strong").inner_html
  end

  def candidate(node,index)
    node.search("td")[index].search("b").inner_html
  end

  desc "some dude"
  task :results => :environment do
    Constituency.find(:all).each do | c |
      unless Result.find_by_constituency_id(c.id)
        puts c.name
        Result.transaction do
          name = c.ec_id.to_i
           name = name < 10 ? "0#{name}" : name.to_s
          new_url = "http://eci.nic.in/archive/March2004/pollupd/ac/states/S01/Aconst#{name}.htm"
          current = open(new_url) { |r| Hpricot(r) }
          (current/"/html/body/div[2]/center/table/tbody/tr").each do |inner|
            if inner.search("td[@width=12%]").size > 0
              votes = inner.search("td[@width=12%] strong").first().inner_html.strip
              percentage = inner.search("td[@width=12%] strong").last().inner_html.strip
              name = inner.search("td[@width=35%] b").inner_html.strip
              party = inner.search("td[@width=35%] strong").inner_html.strip
              party_id = Party.find_by_name(party)
              unless party_id
                party_id = Party.find(:first,:conditions => [ "name like ?", party])
              end
              Result.create(:year => 2004,:name => name,:percentage=>percentage,
              :votes => votes,:party_id => party_id.id,:constituency_id => c.id)
            end
          end
        end
      end
    end
  end
end
