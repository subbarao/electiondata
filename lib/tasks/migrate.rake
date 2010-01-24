namespace :migrate do
  desc "migrate data to new data model"
  task :data => :environment do
    begin
      Decision.transaction do
        CandidateResult.all.each do | candidate |
          puts "Updating #{candidate.winner}"
          winner = Contestant.find_or_create_by_name(candidate.winner)
          runner = Contestant.find_or_create_by_name(candidate.runnerup)

          wparty = Party.find_by_code(candidate.winning_party)
          rparty = Party.find_by_code(candidate.runnerup_party)

          seat = Seat.find_by_name(candidate.constituency.name)
          next if seat.nil?
          contest = seat.contests.find_or_create_by_year(candidate.year)
          total_votes =candidate.total_votes*1000
          contest.update_attributes({
            :votes => total_votes,
            :polled =>total_votes * candidate.turnout
          })

          wresult = Result.find_by_constituency_id_and_year_and_name(candidate.constituency.id,candidate.year,candidate.winner)
          wvotes = wresult.nil? ?  (total_votes *  candidate.winning_percentage) : wresult.votes
          wparty = PartyResult.find_by_constituency_id_and_year_and_name(candidate.constituency.id,candidate.year,candidate.winning_party)
          wpartycode = Party.find_by_code(candidate.winning_party)


          rresult = Result.find_by_constituency_id_and_year_and_name(candidate.constituency.id,candidate.year,candidate.runnerup)
          rvotes = rresult.nil? ? (total_votes *  candidate.runnerup_percentage) : rresult.votes
          rparty = PartyResult.find_by_constituency_id_and_year_and_name(candidate.constituency.id,candidate.year,candidate.runnerup_party)

          rpartycode = Party.find_by_code(candidate.runnerup_party)
          contest.decisions.create({
            :contestant => winner,
            :party => wpartycode,
            :votes => wvotes
          })
          contest.decisions.create({
            :contestant => runner,
            :party => rpartycode,
            :votes => rvotes
          })
          candidate.destroy
          wresult.destroy unless wresult.nil?
          rresult.destroy unless rresult.nil?
          wparty.destroy unless wparty.nil?
          rparty.destroy unless rparty.nil?
          presults = PartyResult.find_all_by_constituency_id_and_year(candidate.constituency_id,candidate.year)
          presults.each do | pre |
            p = Party.find_by_code(pre.name)
            contest.decisions.create(:party => p,:votes => pre.percentage * total_votes)
            pre.destroy
          end
          if CandidateResult.find_all_by_constituency_id(candidate.constituency_id).count == 0
            candidate.constituency.destroy
          end

        end
      end
    rescue
      puts $!
    end
  end
end
