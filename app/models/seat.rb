class Seat < ActiveRecord::Base

  acts_as_mappable

  belongs_to :district

  default_scope :conditions => ["seats.lat IS NOT NULL AND seats.lng IS NOT NULL"]

  has_many :contests,:as => :house, :dependent => :destroy do
    def years
      find(:all,:select => "distinct(contests.year)",:order => "contests.year desc").collect(&:year)
    end
  end

  has_many :decisions,:through => :contests do

    def contestant_values(year)
      for_year(year).reject { | decision | decision.contestant_id.nil? }.collect(&:contestant_values)
    end

    def party_values(year)
      for_year(year).reject { | decision | decision.party_id.nil? }.collect(&:party_values)
    end

    def winner(year)
      find(:first,:conditions => [ "contests.year = ?", year ],:order => "votes desc",:limit => 1)
    end

    def defeated(year)
      find(:first,:conditions => [ "contests.year = ?", year ],:order => "votes desc",:limit => 1,:offset => 1)
    end

    def margin_of_victory(year)
      winner(year).try(:votes) - defeated(year).try(:votes)
    end

  end

  def barcharts
    contests.years.inject({}) do | all_years_chart, year |
      all_years_chart.merge(  year.to_s => decisions.for_year(year).barcharts )
    end
  end

  def piecharts
    contests.years.inject({}) do | all_years_chart, year |
      all_years_chart.merge(  year.to_s => decisions.for_year(year).piecharts )
    end
  end

  def contestant_chart_for_year(year)
    { "cols" => Contestant.google_columns, "rows" => decisions.contestant_values(year) }
  end

  def party_chart_for_year(year)
    { "cols" => Party.google_columns, "rows" => decisions.party_values(year) }
  end

  def contest_overview_for_year(year)
    returning({}) do | overview |
      overview.update(:winner => decisions.winner(year).try(:contestant).try(:name))
      overview.update(:defeated => decisions.defeated(year).try(:contestant).try(:name))
      overview.update(:margin => decisions.margin_of_victory(year))
      overview.update(:total_votes => contests.for_year(year).first.votes)
    end
  end

  def overview
    contests.years.inject({}) do | all_years_chart, year |
      all_years_chart.merge(  year.to_s => contest_overview_for_year(year) )
    end
  end

  def charts
    %w(barcharts piecharts overview).inject({}) do | allcharts, chart |
      allcharts.merge( chart => self.send(chart.to_sym) )
    end
  end

end
