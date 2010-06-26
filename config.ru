#!/usr/bin/env rackup
require File.dirname(__FILE__) + "/timezone"

set :run, false
set :environment, :production

log = File.new("log/production.log", "a+")
STDOUT.reopen(log)
STDERR.reopen(log)

run Sinatra::Application
