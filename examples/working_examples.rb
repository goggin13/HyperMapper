$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib")) 
require '/home/goggin/projects/rails/hyper_mapper/lib/hyper_mapper'

class User
  include HyperMapper::Document

  key :username
  attribute :first
  attribute :last
end

create = <<-BASH
/home/goggin/projects/install/bin/hyperdex add-space <<EOF
space users 
key username
attributes first, last
subspace first, last
tolerate 2 failures
EOF
BASH

system create

user = User.create! username: 'goggin13', first: 'Matt', last: 'Goggin'

puts user

user = User.find('goggin13')
puts user.first
puts user.last

user.first = 'george'
user.save!
puts User.find('goggin13').first
