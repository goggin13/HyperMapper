require 'hyperclient'

client = HyperClient.new '127.0.0.1', 1982

puts "testing 1"
client.put 'users', 'test', [['first', 'matt'], ['last', 'goggin']]

puts client.get 'users', 'test'
puts "test 1 done"

client.put 'users', 'test', [
  ['first', 'Matt'],
  ['last', 'goggin'],
  ['email', 'goggin13@gmail.com'],
  ['posts', {"key" => "value"}],
]

puts client.get 'users', 'test'
pust 'test 2 done'
