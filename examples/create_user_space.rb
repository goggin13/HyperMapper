
system "/home/goggin/projects/install/bin/hyperdex rm-space users"
system "/home/goggin/projects/install/bin/hyperdex rm-space posts"

create = <<-BASH
/home/goggin/projects/install/bin/hyperdex add-space <<EOF
space users 
key id 
attributes 
  username,
  bio,
  salt,
  hashed_password,
  session_id, 
  int created_at,
  int updated_at
subspace username, bio, salt, hashed_password, session_id, created_at, updated_at
tolerate 2 failures
EOF
BASH

system create

create = <<-BASH
/home/goggin/projects/install/bin/hyperdex add-space <<EOF
space posts 
key id 
attributes 
  title,
  content,
  user_id,
  int created_at,
  int updated_at,
  map(string, string) comments
subspace title, content
tolerate 2 failures
EOF
BASH

system create


