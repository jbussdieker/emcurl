require 'eventmachine'

class HTTP < EventMachine::Connection
  def post_init
    @data = ""
    request = File.read("header")
    send_data request
  end
  def receive_data(data)
    @data << data
  end
  def unbind
    puts "Recieved #{@data.length} bytes"
    puts "Connection closed"
    headers, payload = @data.split("\r\n\r\n", 2)
    puts headers
    File.open("output.html", 'w') {|f| f.write(payload) }
    #`gzip -d -f output.html.gz`
    EventMachine::stop_event_loop
  end
end

puts "Connecting to #{ARGV[0]} port #{ARGV[1]}"
EventMachine.run {
  EventMachine.connect ARGV[0], ARGV[1], HTTP
}

