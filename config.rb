require 'socket'

require File.expand_path('../lib/helpers.rb', __FILE__)
require File.expand_path('../lib/client.rb', __FILE__)
require File.expand_path('../lib/server.rb', __FILE__)

module SimpleChat
  DEFAULTS = {
                :hostname => 'localhost',
                :port     => 7000
              }
end