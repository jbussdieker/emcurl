require 'eventmachine'
require 'erb'
require 'uri'

module Emcurl
  class Connection < EventMachine::Connection
    def initialize(uri, options)
      @uri = uri
      @options = options
      @data = ""
    end
    
    def post_init
      template = ERB.new File.read("data/request.erb")
      @headers = template.result(binding).split("\n").join("\r\n") + "\r\n\r\n"

      @headers.split("\r\n").each {|h|puts "> #{h}"} if @options[:verbose]
      puts ">" if @options[:verbose]

      send_data @headers
    end
    
    def receive_data(data)
      @data << data
    end
    
    def unbind
      headers, payload = @data.split("\r\n\r\n", 2)

      headers.split("\r\n").each {|h|puts "< #{h}"} if @options[:verbose]
      puts "<" if @options[:verbose]

      if @options[:output]
        #File.open("output.raw", 'w') {|f| f.write(@data) }
        #File.open("output.http", 'w') {|f| f.write(headers) }
        File.open(@options[:output], 'w') {|f| f.write(payload) }
      else
        puts payload
      end

      puts "* Connection closed" if @options[:verbose]
      EventMachine::stop_event_loop
    end
  end
end
