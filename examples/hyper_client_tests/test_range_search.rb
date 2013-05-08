require 'hyperclient'

system "/home/goggin/projects/install/bin/hyperdex rm-space users_two"

create = <<-BASH
/home/goggin/projects/install/bin/hyperdex add-space <<EOF
space users_two 
key id 
attributes 
  username,
  int created_at
subspace username, created_at
tolerate 2 failures
EOF
BASH

system create

client = HyperClient.new '127.0.0.1', 1982

client.put 'users', 'test', [
  ['username', 'goggin13'],
  ['created_at', 15]
]

puts client.search 'users_two', {'created_at' => 15}
puts "search one completes"

puts client.search 'users_two', {'created_at' => [5, 20] }
puts "search two completes"