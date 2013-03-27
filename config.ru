#!/usr/bin/env rackup
$:.unshift File.dirname(__FILE__) + "/lib"
require "bundler/setup"
require "timezone"

set :run, false
set :environment, :production
set :root, File.dirname(__FILE__)

log = File.new("log/production.log", "a+")
STDOUT.reopen(log)
STDERR.reopen(log)

run Sinatra::Application
