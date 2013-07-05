module SimpleChat
  module CLIParser
    def self.parse(args)
      args = args.join(' ')

      {
        :handle   => parse_handle(args),
        :hostname => args[/-h ([\w\.]+)/, 1],
        :port     => args[/-p (\d+)/, 1]
      }.delete_if { |k, v| v.nil? }
    end

    def self.parse_handle(str)
      str = str[/-n ([^-]+)/, 1]
      str ? str.strip.sub(' ', '_') : nil
    end
  end

  module TimeOutHelper
    require 'timeout'
    
    def self.quiet_timeout(seconds)
      Timeout::timeout(seconds) {
        yield
      }
    rescue Timeout::Error => e
    end
  end
end

class String
  def blue
    "\e[34m#{self}\e[0m"
  end

  def orange
    "\e[32m#{self}\e[0m"
  end
end