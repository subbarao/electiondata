class Seat < ActiveRecord::Base

  UI_INFO  = %w(barcharts piecharts overview)

  acts_as_mappable

  belongs_to :district

  default_scope :conditions => ["seats.lat IS NOT NULL AND seats.lng IS NOT NULL"],:order => "seats.name"

  has_many :contests,:as => :house, :dependent => :destroy do
    def years
      find( :all, :select => "distinct(contests.year)", :order => "contests.year desc" ).collect(&:year)
    end
  end

  has_many :decisions,:through => :contests

  def construct(chart_type)
    contests.years.inject({}) do | all_years_chart, year |
      all_years_chart.merge(  year.to_s => decisions.for_year(year).send(chart_type.to_sym) )
    end
  end

  def charts
    UI_INFO.inject({}) do | allcharts, chart_type |
      allcharts.merge( chart_type => self.send( :construct, chart_type ) )
    end.merge("info" => self.attributes.slice("name","lat","lng") )
  end

end
