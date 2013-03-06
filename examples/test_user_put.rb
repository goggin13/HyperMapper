require 'hyperclient'

# create space command 
create = <<-BASH
hyperdex add-space <<EOF
space users 
key username
attributes 
  first, 
  last, 
  email, 
  map(string, string) posts
subspace first, last, email, posts
tolerate 2 failures
EOF
BASH

# Create the space
system create

client = HyperClient.new '127.0.0.1', 1982

puts "testing 1"
client.put 'users', 'test', [['first', 'matt'], ['last', 'goggin']]

puts client.get 'users', 'test'
puts "test 1 done"


# THIS FAILS
client.put 'users', 'test', [
  ['first', 'Matt'],
  ['last', 'goggin'],
  ['email', 'goggin13@gmail.com'],
  ['posts', {"key" => "value"}],
]

puts client.get 'users', 'test'
pust 'test 2 done'
