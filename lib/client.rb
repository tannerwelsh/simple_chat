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
        response = get_response

        exit if response && response =~ EXIT_OR_QUIT
      end
    end

    def listen(delay = 0.5)
      TimeOutHelper.quiet_timeout(delay) do
        message = server.gets.chomp
        STDOUT.puts(format_message(message))
      end
    end

    def get_response(delay = 0.5)
      TimeOutHelper.quiet_timeout(delay) do
        response = STDIN.gets.chomp
        server.puts(format_response(response))
        return response
      end
    end

    def format_message(message)
      message =~ /\A\[/ ? message.orange : message.blue
    end

    def format_response(response)
      "[#{handle}] #{response}"
    end
  end
end