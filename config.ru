#!/usr/bin/env rackup
$:.unshift File.dirname(__FILE__) + "/lib"
require "bundler/setup"
require "sinatra"
require "newrelic_rpm"

ENV["RACK_ENV"] = RACK_ENV = "production"

log = File.new("log/production.log", "a+")
STDOUT.reopen(log)
STDERR.reopen(log)

set :run, false
set :environment, RACK_ENV
set :root, File.dirname(__FILE__)

require "timezone"
run Sinatra::Application
