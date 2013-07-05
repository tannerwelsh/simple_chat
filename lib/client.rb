module SimpleChat
  class Client
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
        listen
        respond
      end
    end

    def listen(delay = 1)
      TimeOutHelper.quiet_timeout(delay) do
        message = server.gets.chomp
        STDOUT.puts(format_message(message))
      end
    end

    def respond(delay = 1)
      TimeOutHelper.quiet_timeout(delay) do
        response = STDIN.gets.chomp
        exit if response =~ /\A(exit|quit)\z/
        server.puts(format_response(response))
      end
    end

    def format_message(message)
      if message =~ /\A\[/
        message.orange
      else
        message.blue
      end
    end

    def format_response(response)
      "[#{handle}] #{response}"
    end
  end
end