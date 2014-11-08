require 'optparse'

module Emcurl
  module Options
    def self.parse(args)
      options = {}

      opts = OptionParser.new do |opts|
        opts.banner = "Usage: emcurl [options] url"
        opts.on("-0", "Use HTTP 1.0 for requests") do |v|
          options[:version] = "1.0"
        end
        opts.on("-H HOST", "--host HOST", "Use override the host header") do |v|
          options[:host] = v
        end
        opts.on("-X METHOD", "--request METHOD", "Use HTTP method for requests") do |v|
          options[:method] = v
        end
        opts.on("-o file", "--output file", "Write output to file") do |v|
          options[:output] = v
        end
        opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
          options[:verbose] = v
        end
        opts.on_tail("--version", "Show version") do
          puts "emcurl v#{Emcurl::VERSION}"
          exit
        end
      end

      opts.parse!(args)
      options[:url] = args.first || raise(ArgumentError.new("Invalid URL"))
      options
    end
  end
end
