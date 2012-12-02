require "emcurl/version"
require "emcurl/options"
require "emcurl/connection"

module Emcurl
  def self.configure(options)
    default_options = {
      :method => "GET",
      :version => "1.1",
    }
    @options = default_options.merge(options)
    @uri = URI.parse(@options[:url])
  end

  def self.run
    puts "* About to connect() to #{@uri.host} port #{@uri.port}" if @options[:verbose]
    EventMachine.run {
      EventMachine.connect @uri.host, @uri.port, Emcurl::Connection, @uri, @options
    }
  end
end
