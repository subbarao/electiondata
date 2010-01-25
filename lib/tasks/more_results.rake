require 'rubygems'
require 'open-uri'
require 'hpricot'
namespace :create do
  desc "some dude"
  task :more_results => :environment do
    Constituency.find(:all).each do | c |
      #unless Result.find_by_constituency_id(c.id)
      puts c.name
      PartyResult.transaction do
        name = c.ec_id.to_i
        name = name < 10 ? "0#{name}" : name.to_s
        new_url = "http://eci.nic.in/archive/March2004/pollupd/ac/states/S01/Partycomp#{name}.htm"
        current = open(new_url) { |r| Hpricot(r) }
        years = [2004,1999,1994,1989,1985,1983,1978]
        party_results = (current/"/html/body/center/table/tbody/tr")

        (2...party_results.size).each do |i|
          party_nodes = (party_results[i]/"td/p/font")
          party_name = party_nodes[0].inner_html.strip
          years.each_with_index do |year,index|
            votes = party_nodes[index+2].inner_html
            if votes.match(/\d+/)
              PartyResult.create(:year =>year,:percentage =>votes.to_f,:name =>party_name,
              :constituency_id =>c.id)
            end
          end
        end
        (current/"/html/body/center/center/table[@width=90%]/tbody/tr").each do |inner|
          if (inner/"td[@bgcolor]").size == 0
            year = (inner/"td/font/b").inner_html
            nodes = (inner/"td/b/font:last-child")
            total = nodes[0].inner_html
            turnout = nodes[1].inner_html
            winner = nodes[2].inner_html
            percentage = nodes[3].inner_html
            wi_party =nodes[4].inner_html.strip
            runner = nodes[5].inner_html
            runner_percentage = nodes[6].inner_html
            runner_party = nodes[7].inner_html.strip
            CandidateResult.create(:constituency_id=>c.id,
            :year => year,
            :total_votes => (total*1000),
            :turnout=>turnout,
            :winner=>winner,
            :winning_party => wi_party,
            :winning_percentage=>percentage,
            :runnerup => runner,
            :runnerup_party => runner_party,
            :runnerup_percentage=>runner_percentage)
          end
        end

      end

    end
    #end
  end
  task :one => :environment do
    #unless Result.find_by_constituency_id(c.id)
    c = Constituency.find(180)
    name = c.ec_id.to_i
    name = name < 10 ? "0#{name}" : name.to_s
    PartyResult.transaction do
      PartyResult.destroy_all(:constituency_id => c.id)
      CandidateResult.destroy_all(:constituency_id => c.id)
      new_url = "http://eci.nic.in/archive/March2004/pollupd/ac/states/S01/Partycomp#{name}.htm"
      current = open(new_url) { |r| Hpricot(r) }
      years = [2004,1999,1994,1989,1985,1983,1978]
      party_results = (current/"/html/body/center/table/tbody/tr")

      (2...party_results.size).each do |i|
        party_nodes = (party_results[i]/"td/p/font")
        party_name = party_nodes[0].inner_html.strip
        years.each_with_index do |year,index|
          votes = party_nodes[index+2].inner_html
          if votes.match(/\d+/)
            PartyResult.create(:year =>year,:percentage =>votes.to_f,:name =>party_name,
            :constituency_id =>c.id)
          end
        end
      end
      (current/"/html/body/center/center/table[@width=90%]/tbody/tr").each do |inner|
        if (inner/"td[@bgcolor]").size == 0
          year = (inner/"td/font/b").inner_html
          nodes = (inner/"td/b/font:last-child")
          total = nodes[0].inner_html
          turnout = nodes[1].inner_html
          winner = nodes[2].inner_html
          percentage = nodes[3].inner_html
          wi_party =nodes[4].inner_html.strip
          runner = nodes[5].inner_html
          runner_percentage = nodes[6].inner_html
          runner_party = nodes[7].inner_html.strip
          CandidateResult.create(:constituency_id=>c.id,
          :year => year,
          :total_votes => (total*1000),
          :turnout=>turnout,
          :winner=>winner,
          :winning_party => wi_party,
          :winning_percentage=>percentage,
          :runnerup => runner,
          :runnerup_party => runner_party,
          :runnerup_percentage=>runner_percentage)
        end
      end

    end
  end
end
