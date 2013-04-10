
system "/home/goggin/projects/install/bin/hyperdex rm-space users"

create = <<-BASH
/home/goggin/projects/install/bin/hyperdex add-space <<EOF
space users 
key id 
attributes 
  username,
  first, 
  last, 
  email, 
  int created_at,
  int updated_at,
  map(string, string) posts
subspace first, last, email, posts
tolerate 2 failures
EOF
BASH

system create

#system "/home/goggin/projects/install/bin/hyperdex rm-space "
