#!/usr/bin/env rackup
$:.unshift File.dirname(__FILE__) + "/lib"
require "bundler/setup"
require "sinatra"

log = File.new("log/production.log", "a+")
STDOUT.reopen(log)
STDERR.reopen(log)

set :run, false
set :environment, :production
set :root, File.dirname(__FILE__)

require "timezone"
run Sinatra::Application
