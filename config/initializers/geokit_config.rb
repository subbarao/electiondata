if defined? Geokit

	# These defaults are used in Geokit::Mappable.distance_to and in acts_as_mappable
	Geokit::default_units = :kms
	Geokit::default_formula = :sphere

	# This is the timeout value in seconds to be used for calls to the geocoder web
	# services.  For no timeout at all, comment out the setting.  The timeout unit
	# is in seconds. 
	Geokit::Geocoders::timeout = 3

	# These settings are used if web service calls must be routed through a proxy.
	# These setting can be nil if not needed, otherwise, addr and port must be 
	# filled in at a minimum.  If the proxy requires authentication, the username
	# and password can be provided as well.
	Geokit::Geocoders::proxy_addr = nil
	Geokit::Geocoders::proxy_port = nil
	Geokit::Geocoders::proxy_user = nil
	Geokit::Geocoders::proxy_pass = nil

	# This is your yahoo application key for the Yahoo Geocoder.
	# See http://developer.yahoo.com/faq/index.html#appid
	# and http://developer.yahoo.com/maps/rest/V1/geocode.html
    
	# This is your Google Maps geocoder key. 
	# See http://www.google.com/apis/maps/signup.html
	# and http://www.google.com/apis/maps/documentation/#Geocoding_Examples
	Geokit::Geocoders::google = 'ABQIAAAAlgBkrxtozPq6BJRUDdohQBSvO9wEK1VL9ijrFsVgreQc7pMV_RQCkG2f2oL1rhfewyrc9L2GJVZVZw'
  
	Geokit::Geocoders::provider_order = [:google,:us]
end
