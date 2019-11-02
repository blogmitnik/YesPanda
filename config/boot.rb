require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

# Set up for Houston gem
ENV['APPLE_CERTIFICATE'] ||= File.expand_path('../../apns-dev.pem', __FILE__)
ENV['APN_CERTIFICATE_PASSPHRASE'] ||= '987987987'

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
