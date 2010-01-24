# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_electiondata_session',
  :secret      => 'a54091f3a37e97083521402bb9cd31dea903b2155e106d92a0a7af7bcb887d3ada089c993940e04e42c32023d3b2476873d2bdad54ac3e091aaa9c1fac446f6c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
