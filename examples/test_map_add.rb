require 'hyperclient'

system "/home/goggin/projects/install/bin/hyperdex rm-space users_two"

create = <<-BASH
/home/goggin/projects/install/bin/hyperdex add-space <<EOF
space users_two 
key id 
attributes 
  username,
  int created_at,
  map(string, string) comments
subspace username, created_at
tolerate 2 failures
EOF
BASH

system create

client = HyperClient.new '127.0.0.1', 1982

client.put 'users_two', 'test', [
  ['username', 'goggin13'],
  ['created_at', 15],
  ['comments', {'1' => 'hello', '2' => 'goodbye'}]
]


client.map_add 'users_two', 'test', {'comments' => {'3' => 'farewell'}}
puts client.get 'users_two', 'test'

client.map_add 'users_two', 'test', {'comments' => {'1' => 'hello2'}}
puts client.get 'users_two', 'test'

# THIS FAILS
client.map_add 'users_two', 'test', {'comments' => {'1' => 'hello3', '2' => 'goodbye3'}}
puts client.get 'users_two', 'test'

# This syntax doesn't seem to work
# client.map_remove 'users_two', 'test', {'comments' => ['1']}
# puts client.get 'users_two', 'test'