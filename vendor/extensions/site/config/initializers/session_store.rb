# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_atch_session',
  :secret      => 'caba49e7b21c2fb7122f6864bf8138249ba31efe11fa90fd329f7680505f3c171e5b077d10b7471de10ff19de862c3368fcc12372b7a4a8e6f812a2961ae96ba'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store