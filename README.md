# SimpleChat

A very simple socket-based chat application built in Ruby.

## Dev notes

### Feature list

- Server with standard protocol for message passing
- Server tracks list of connected clients
- Client sign in
- Client can send broadcast messages to all other connected clients
- Client can send specific messages to other clients

### Server interface

```ruby
require 'pneumatic'

# Create a new server
server = Pneumatic::Server.new(port: 7070)

# Start the server
server.start

# List the connected clients
server.clients

# Deliver a message
server.message(to: <CLIENT>, from: <CLIENT>, content: <CONTENT>)

# Broadcast a message
server.broadcast(content: <CONTENT>)
```

### Client interface

```ruby
require 'pneumatic'

# Create a new client
client = Pneumatic::Client.new(server: 'server-address.local', port: 7070)

# Sign in as a user
client.sign_in(username: 'murdoch')

# Show other connected users
client.neighbors

# Send a message to a specific user
client.message(to: 'verne', content: "Hey buddy, how's the book coming")

# Broadcast a message to all users on the network
client.broadcast(content: "Everybody look at me!")
```
