module SimpleChat
  class ClosedServerError < SocketError
  end

  class Server
    attr_reader :socket
    private :socket

    def initialize(opts = {})
      @hostname = opts.fetch(:hostname) { DEFAULTS[:hostname] }
      @port     = opts.fetch(:port)     { DEFAULTS[:port]     }
      @socket   = TCPServer.new(@hostname, @port.to_i)
      @clients  = []
      @logger   = STDOUT
    end

    def start
      @logger.puts("Simple Chat server is running.")
      @logger.puts("Listening for connections on #{@hostname}:#{@port}...")

      loop do
        if client = accept_client
          @clients << client
          connections << respond_to_client(client)
        end
      end
    end

    def stop
      connections.each(&:kill)
      @logger.puts("closed.")
      @logger.close
    end

    def respond_to_all(opts = {})
      message = opts.fetch(:message)
      from    = opts.fetch(:from)

      @clients.each { |client| client.puts(message) unless client == from }
    end

    def respond_to_client(client_connection)
      Thread.new(client_connection) do |client|
        @logger.puts("New connection with #{client}...")
        @logger.puts("Clients: #{@clients}")

        client.puts("Welcome! There are #{@clients.count} people online.")

        loop do
          message = client.gets.chomp
          break if message == 'quit'
          if message
            @logger.puts("Message from #{client}: #{message}")
            respond_to_all(:message => message, :from => client)
          end
        end
      end
    end

    def can_connect?
      !!(socket)
    end

    def accept_client
      can_connect? ? socket.accept : raise(ClosedServerError, "The server is not accepting new connections.")
    end

    def connections
      @connections ||= []
    end
  end
end