module SimpleChat
  class Client
    include TimeOutHelper

    attr_reader :server, :handle
    private :server

    def initialize(opts = {})
      @hostname = opts.fetch(:hostname) { DEFAULTS[:hostname] }
      @port     = opts.fetch(:port)     { DEFAULTS[:port] }
      @handle   = opts.fetch(:handle)   { 'anonymous' }
      @server   = TCPSocket.open(@hostname, @port)
    end

    def start
      loop do
        response = nil

        quiet_timeout(1) {
          message = server.gets.chomp
          
          if message =~ /\A\[/
            message = message.orange
          else
            message = message.blue
          end

          STDOUT.puts(message)
        }

        quiet_timeout(1) {
          response = STDIN.gets.chomp
          exit if response =~ /(exit|quit)/
          server.puts("[#{handle}] #{response}")
        }
      end
    end
  end
end