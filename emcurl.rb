require 'eventmachine'
require 'ruby-debug'
require 'erb'
require 'uri'

module EMCURL
  class HTTP < EventMachine::Connection
    def initialize(*args)
      super
      @uri = URI.parse(args[0])
    end
    
    def post_init
      @data = ""
      template = ERB.new File.read("header.erb")
      @headers = template.result(binding)
      send_data @headers
    end
    
    def receive_data(data)
      @data << data
    end
    
    def unbind
      puts "Recieved #{@data.length} bytes"
      puts "Connection closed"
      File.open("output.raw", 'w') {|f| f.write(@data) }
      headers, payload = @data.split("\r\n\r\n", 2)
      File.open("output.html", 'w') {|f| f.write(payload) }
      File.open("output.http", 'w') {|f| f.write(headers) }
      EventMachine::stop_event_loop
    end
  end
  
  class Curl
    def self.run(url)
      uri = URI.parse(url)
      puts "Connecting to #{uri.host} port #{uri.port}"
      EventMachine.run {
        EventMachine.connect uri.host, uri.port, HTTP, url
      }
    end
  end
end
