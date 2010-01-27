class Seat < ActiveRecord::Base

  acts_as_mappable

  belongs_to :district

  default_scope :conditions => ["seats.lat IS NOT NULL AND seats.lng IS NOT NULL"],:order => "seats.name"

  has_many :contests,:as => :house, :dependent => :destroy do
    def values(method)
      all.inject({}) do | all_years_chart, contest |
        all_years_chart.merge(  contest.year.to_s => contest.send(method) )
      end
    end
  end

  has_many :decisions,:through => :contests

  def core_info
    attributes.slice("name","lat","lng")
  end

  def charts
    {
      "barcharts" => contests.values("barcharts"),
      "piecharts" => contests.values("piecharts"),
      "overview"  => contests.values("overview"),
      "info"      => core_info
    }
  end

end
