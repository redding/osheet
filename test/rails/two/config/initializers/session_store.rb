# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_two_session',
  :secret      => '4bd519bd5597758c71c72236b1a977acdf48b308fbcb21df409357967e902e9972809c4b8efaa3726758f3e8a9f2a0e7a90f69fb726f2e5e4d7c6bc524bec00a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
