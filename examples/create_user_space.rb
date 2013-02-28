create = <<-BASH
/home/goggin/projects/install/bin/hyperdex add-space <<EOF
space users 
key username
attributes first, last, posts
subspace first, last, posts
tolerate 2 failures
EOF
BASH

system create
