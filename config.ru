#!/usr/bin/env rackup
$:.unshift File.dirname(__FILE__) + "/lib"
require "timezone"

set :run, false
set :environment, :production

log = File.new("log/production.log", "a+")
STDOUT.reopen(log)
STDERR.reopen(log)

run Sinatra::Application
