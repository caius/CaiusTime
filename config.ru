#!/usr/bin/env rackup
require 'rubygems'
require 'sinatra'

Sinatra::Application.default_options.merge!(
  :run => false,
  :env => :production
)

log = File.new("log/production.log", "a+")
STDOUT.reopen(log)
STDERR.reopen(log)


require File.dirname(__FILE__) + "/timezone"
run Sinatra.application
