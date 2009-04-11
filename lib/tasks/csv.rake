require 'rubygems'
require 'faster_csv'
namespace :csv do
  desc "inc some dude"
  task :phase2 => :environment do
    mc = []
    AssemblySeat.transaction do
      #AssemblyNomination.destroy_all
      FasterCSV.foreach("elections2.csv") do | row |
        if seat = AssemblySeat.find_by_name(row[1].upcase)
          options = {}
          phase = row[2].to_i
          election_date = (phase == 1) ? Date.parse("4/16/2009") : Date.parse("4/23/2009")
          year = 2009
          seat.update_attributes(:election_date => election_date, :category => row[7], :phase => phase , :year => year)
          party = Party.find_by_code(row[8])
          puts row[8] unless party
          seat.nominations.create(:name => row[4],:party_id => party.id, :election_symbol => row[10],:age => row[6],:sex=>row[5])
        end
      end
    end
  end
  task :parse => :environment do
    mc = []
    AssemblySeat.transaction do
      AssemblyNomination.destroy_all
      FasterCSV.foreach("elections.csv") do | row |
        if seat = AssemblySeat.find_by_name(row[1].upcase)
          options = {}
          phase = row[2].to_i
          election_date = (phase == 1) ? Date.parse("4/16/2009") : Date.parse("4/23/2009")
          year = 2009
          seat.update_attributes(:election_date => election_date, :category => row[7], :phase => phase , :year => year)
          party = Party.find_by_code(row[8])
          seat.nominations.create(:name => row[4],:party_id => party.id, :election_symbol => row[10],:age => row[6],:sex=>row[5])
        end
      end
    end
  end
end
