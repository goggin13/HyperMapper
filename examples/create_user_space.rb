create = <<-BASH
/home/goggin/projects/install/bin/hyperdex add-space <<EOF
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

system create
