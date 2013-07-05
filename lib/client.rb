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
      # TODO: block new input if user is typing (smarter resource management)
      loop do
        listen
        respond
      end
    end

    def listen(delay = 0.5)
      TimeOutHelper.quiet_timeout(delay) do
        message = server.gets.chomp
        STDOUT.puts(format_message(message))
      end
    end

    def respond(delay = 0.5)
      TimeOutHelper.quiet_timeout(delay) do
        response = STDIN.gets.chomp
        server.puts(format_response(response))
        exit if response =~ EXIT_OR_QUIT
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